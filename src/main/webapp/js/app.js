/* ==========================================================
   Tourist Information System - client-side helpers
   1. Loads real photographs for every .img-slot element
   2. Runs the city slider on the home page
   3. Mobile navigation toggle
   All tourist DATA still comes from the XML file through the
   Servlets - this script only adds photographs and polish.
   ========================================================== */
(function () {
    'use strict';

    var WIKI_API = 'https://en.wikipedia.org/api/rest_v1/page/summary/';
    var pending = {};

    /* ---------- 1. Photo loading (Wikipedia lead image or custom URL) ---------- */

    var SEARCH_API = 'https://en.wikipedia.org/w/api.php?action=query&format=json&origin=*'
        + '&generator=search&gsrlimit=1&prop=pageimages&piprop=thumbnail%7Coriginal&pithumbsize=1280&gsrsearch=';

    /* Fallback: if the exact article title is not found, search Wikipedia for the best match. */
    function searchFallback(title) {
        return fetch(SEARCH_API + encodeURIComponent(title))
            .then(function (r) {
                if (!r.ok) { throw new Error('HTTP ' + r.status); }
                return r.json();
            })
            .then(function (d) {
                var pages = d.query && d.query.pages ? d.query.pages : null;
                var page = null;
                if (pages) { for (var k in pages) { page = pages[k]; break; } }
                if (!page || (!page.thumbnail && !page.original)) { throw new Error('no image'); }
                return {
                    thumb: page.thumbnail ? page.thumbnail.source : null,
                    orig: page.original ? page.original.source : null,
                    width: page.original ? page.original.width : 0
                };
            });
    }

    function getSummary(title) {
        if (!title) {
            return Promise.reject(new Error('no title'));
        }
        var key = 'tis:' + title;
        try {
            var saved = sessionStorage.getItem(key);
            if (saved) {
                return Promise.resolve(JSON.parse(saved));
            }
        } catch (e) { /* storage unavailable - ignore */ }

        if (!pending[title]) {
            pending[title] = fetch(WIKI_API + encodeURIComponent(title.replace(/ /g, '_')))
                .then(function (r) {
                    if (!r.ok) { throw new Error('HTTP ' + r.status); }
                    return r.json();
                })
                .then(function (d) {
                    var info = {
                        thumb: d.thumbnail ? d.thumbnail.source : null,
                        orig: d.originalimage ? d.originalimage.source : null,
                        width: d.originalimage ? d.originalimage.width : 0
                    };
                    if (!info.thumb && !info.orig) { throw new Error('no image'); }
                    return info;
                })
                .catch(function () { return searchFallback(title); })
                .then(function (info) {
                    try { sessionStorage.setItem(key, JSON.stringify(info)); } catch (e) { /* ignore */ }
                    return info;
                });
        }
        return pending[title];
    }

    /* Wikimedia only serves a thumbnail if it is not larger than the original. */
    function sizedUrl(info, size) {
        if (!info.thumb) { return info.orig; }
        if (info.orig && info.width && info.width <= size) { return info.orig; }
        return info.thumb.replace(/\/\d+px-/, '/' + size + 'px-');
    }

    function preload(url) {
        return new Promise(function (resolve, reject) {
            var img = new Image();
            img.onload = function () { resolve(url); };
            img.onerror = function () { reject(new Error('image failed')); };
            img.src = url;
        });
    }

    function resolveImage(title, size, direct) {
        if (direct) {
            return preload(direct);
        }
        return getSummary(title).then(function (info) {
            var primary = sizedUrl(info, size);
            if (!primary) { throw new Error('no image'); }
            return preload(primary).catch(function () {
                if (info.orig && info.orig !== primary) { return preload(info.orig); }
                throw new Error('image failed');
            });
        });
    }

    function applyImage(el) {
        var wiki = el.getAttribute('data-wiki');
        var direct = el.getAttribute('data-img');
        if (!wiki && !direct) { return; }
        var size = parseInt(el.getAttribute('data-size'), 10) || 960;
        resolveImage(wiki, size, direct).then(function (url) {
            el.style.backgroundImage = 'url("' + url + '")';
            el.classList.add('is-loaded');
        }).catch(function () {
            el.classList.add('no-image');
        });
    }

    var slots = document.querySelectorAll('.img-slot');
    if ('IntersectionObserver' in window) {
        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    observer.unobserve(entry.target);
                    applyImage(entry.target);
                }
            });
        }, { rootMargin: '300px' });
        Array.prototype.forEach.call(slots, function (el) { observer.observe(el); });
    } else {
        Array.prototype.forEach.call(slots, applyImage);
    }

    /* ---------- 2. Home page city slider ---------- */

    var stage = document.getElementById('stage');
    if (stage) {
        var thumbs = Array.prototype.slice.call(stage.querySelectorAll('.thumb[data-city]'));
        var layers = [document.getElementById('bgA'), document.getElementById('bgB')];
        var content = document.getElementById('stageContent');
        var elNum = document.getElementById('stageNum');
        var elTag = document.getElementById('stageTag');
        var elTitle = document.getElementById('stageTitle');
        var elDesc = document.getElementById('stageDesc');
        var elLink = document.getElementById('stageLink');
        var strip = document.getElementById('stageStrip');
        var siteBg = document.querySelector('.site-bg');
        var current = 0;
        var visible = 0;
        var timer = null;

        var pad = function (n) { return (n < 10 ? '0' : '') + n; };

        var show = function (i) {
            current = (i + thumbs.length) % thumbs.length;
            var t = thumbs[current];
            var mine = current;

            thumbs.forEach(function (b, k) { b.classList.toggle('active', k === current); });
            elNum.textContent = pad(current + 1);
            elTag.textContent = t.getAttribute('data-tag');
            elTitle.textContent = t.getAttribute('data-city');
            elDesc.textContent = t.getAttribute('data-desc');
            elLink.setAttribute('href', t.getAttribute('data-href'));
            elLink.textContent = 'Explore ' + t.getAttribute('data-city') + ' \u203A';

            content.classList.remove('in');
            void content.offsetWidth;
            content.classList.add('in');

            if (strip) {
                strip.scrollTo({ left: Math.max(0, t.offsetLeft - 20), behavior: 'smooth' });
            }

            resolveImage(t.getAttribute('data-wiki'), 1920, '').then(function (url) {
                if (mine !== current) { return; }
                var next = 1 - visible;
                layers[next].style.backgroundImage = 'url("' + url + '")';
                layers[next].classList.add('on');
                layers[visible].classList.remove('on');
                visible = next;
                if (siteBg) { siteBg.style.backgroundImage = 'url("' + url + '")'; }
            }).catch(function () { /* keep the gradient background */ });
        };

        var restart = function () {
            clearInterval(timer);
            timer = setInterval(function () {
                if (!document.hidden) { show(current + 1); }
            }, 8000);
        };

        thumbs.forEach(function (b, k) {
            b.addEventListener('click', function () { show(k); restart(); });
        });
        var prev = document.getElementById('stagePrev');
        var nextBtn = document.getElementById('stageNext');
        if (prev) { prev.addEventListener('click', function () { show(current - 1); restart(); }); }
        if (nextBtn) { nextBtn.addEventListener('click', function () { show(current + 1); restart(); }); }

        show(0);
        restart();
    }

    /* ---------- 3. Mobile navigation ---------- */

    var toggle = document.getElementById('navToggle');
    var links = document.getElementById('navLinks');
    if (toggle && links) {
        toggle.addEventListener('click', function () {
            var open = links.classList.toggle('open');
            toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
        });
    }
})();
