Return-Path: <live-patching+bounces-2314-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EOw/MuvS1Gl/xwcAu9opvQ
	(envelope-from <live-patching+bounces-2314-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 11:48:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F6A3AC499
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 11:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C19F1300D6BE
	for <lists+live-patching@lfdr.de>; Tue,  7 Apr 2026 09:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585B63A758F;
	Tue,  7 Apr 2026 09:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DDGqBCSI"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304753A6F18
	for <live-patching@vger.kernel.org>; Tue,  7 Apr 2026 09:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775555172; cv=pass; b=XbZoZQjHEzVi1nXi19tlYi5rZuaR+fKskr1nT2x6Dyf3pJs9QXRy5xbFwuoVHgI4EIFCJwbdJOzwkWE9TfobleSbeHFfuMmcwzVRBqCzjcilCKahG99Il5ayysD4c3Hz9KlF8XeLKMwa0RuCN33o3PlBcHgXZHl9TI/lt6rnnUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775555172; c=relaxed/simple;
	bh=h6lhxXkUnK9to4mvDTJLoQRynH+qEyeFNGNMe3B9/Sg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RCOt8hXr17nBB2hLCPqL9Tc0KhhZt67FIuOMlKq50lKc5JFkjGWMl2cY7GlNLcW8DfBaIN0QZdiHpHxdH4zT2JqBxs6sBXa1TVcoOaYk0u/OWx+rN1sqikUvQRtIGF9IrXFaxZCtDPua5xxNhRxigZODNjHx6+3hXxuD5SMP1P8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DDGqBCSI; arc=pass smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-79853c0f5b9so78804427b3.0
        for <live-patching@vger.kernel.org>; Tue, 07 Apr 2026 02:46:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775555168; cv=none;
        d=google.com; s=arc-20240605;
        b=XWO0lJlHWbEVJnL8GdXUU2HB85zkHFWI9VF9wVOl7hn+eBTLFx8XBjB8eCR5UZFS3i
         XFF+FGR3/qiM+XhIqlD8QAtu5Y7aW96tP9F7o/0mVwZl50bvRdvgG+ePTJdZhk7GQMe/
         ZGLEHBzT44V3Mk6+6G15+rF6HYP9aEjr0spePbuQfd6fd5zk3TTiRjW1H3KIlxuKdXBJ
         G51Ck1LCH0PXEX58GX1uWNTiKiE94LWRJAzdjD7y4Ol30dp/pV+shzN6SdldVwjuzvKj
         sGJ7MCvLjFKfuDZMvkB/GRvuAg1ySRrk1zinF4sfFhLwH27AeGHjc6ZNg8QW3Nl3aAqs
         lxPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9E60mk44Eky+PTLd9t+EfmiFZLuGKI0mwfBKJlhAG9Y=;
        fh=pCZaW7Gxt6BX0xsmO1YHIQ2HdhFFmsPHbtfLXdp0eDk=;
        b=RxwOC/E8pKeHLOydoiJyHLH/0u9tTmGO6+7lgJ0+51JFiBVihXt5R4E+EYsI3YRLh9
         xDHmwoqGCrvFJn1BWjbStaWKuicqZdFXEVpOs7TjszertxlrrvVHVFJqZtKCtvMsQ4oA
         5yJMT61iKG+FMKYdXxxWwtWAjBK2nMrSgP1zsTz6lz/7vkkXDD3ig7Aa7xgFOhW3BTgw
         3vp3KelMD+BCbRXvvxD3G9hbuXYTT1NnrjvD2UM3zBPt+scVbx6p4EFCoGPKMv5xpHvw
         SMs1QShkuq4+df2U1+yR/7GB0v3BLbngURYUlVploe5GLT094YZ9T6u8+75ohGVswX9L
         PxfA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775555168; x=1776159968; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9E60mk44Eky+PTLd9t+EfmiFZLuGKI0mwfBKJlhAG9Y=;
        b=DDGqBCSInwehBp2B1z3jnzM2aWT0BQnQ9xDoQudeZZwVfqPJk0k4Sl/AdnXtEwZE1B
         hm/PynS6qBFEpyGStOoDUtmIuAtgP94Sih3W6Xe+eHmeD44LzqyRh94G0eDL42wygjoV
         w2/7QEKaRHAZ8lESkx3jlIRxM9SqsgIoQX5MsTpJzB1AceRn6/nEc0LozvtpDWkpOhWv
         4ZJy61o1BPNnUCgJhGkI/pEs40CkPSTKmQ6RBdrarASBtkkCvXRyIur2fxvwRUT077I6
         A+62S1j4uO75SzCakBmOXiT8fsGwr9BgPpxne6Zf5PKOrDUE8NPDF3KTKhmlytl8F5mY
         /f+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775555168; x=1776159968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9E60mk44Eky+PTLd9t+EfmiFZLuGKI0mwfBKJlhAG9Y=;
        b=m4dHdTrAMpMWUhujFebouA3d/1I9FOKRP7EtGKu7032grpaKl17PPQYxdwr3gHqs7w
         YxrTs/hOINZdAfXDrCyvhWxrytQ5p+htV3VG9UZ5Shj8OnKurlAd8Kt0Qqk9f45hh7ZL
         tfFnIxfyXO0JcJXEwa5lLVa3uVwyQ3WgZAxVhacyFih1GDWmj9JZkIBw8Ra6ZXskfS/e
         y0Atl3VWvjJBcKSD1qHUcelt0MvXv2j/RTJeOFvIhyMbpUsRfa3VJWX1AjV6IPrIgJzt
         mcKXErpTlo/Hrv2m7uwW7JrOvMb9fZ7hXilcMkUGkWwJZc/MAz1z+nA9IB0V85XC6v92
         yiDA==
X-Forwarded-Encrypted: i=1; AJvYcCU0LJ5NjBSr8/Rb/MzitwEvIYAYhey3sbP9ojitLKgOtU6G2pgLB/0ZJx7+SKB/u2q57u7UF9DjKNs3PKMC@vger.kernel.org
X-Gm-Message-State: AOJu0YxPYcuXmLDDuCTCImfu0gMk/OWihJ0rfAjr+o6jWo0AqUdjjI8n
	x9Y0yQZuoXkiHm1WdwmUweRMREBfTjiDmhMHcgOuxsWByOGpOrUsWYPUZaef24o3hOZX8Oz+/Pc
	H2YMWXti4v/+RUL4DdS/m2L/PW0/WNcY=
X-Gm-Gg: AeBDievgiaUT56ivtQzDMXnAz776cyc9fvOaAnQP++CXWKq4ntpUMIVWyg1XFMZBrgk
	sbuMTd3E764tY0xu7ukzzs1jGEEwDIz6gJ2/kcBjTlUHCNtihAb/29wl7UN8m3v5Fer48eTXlii
	sdWS53KxRwB2stq6a8QUyNAwdGHgXJ/naBjwKdMz30nrZ/oyYqXpuNrp/gc6H1kbKKaEtQM0sXQ
	mlwglXoyy6E2tbMrKt6+APAXcPNFWQINkWEI1FXjZMAz450eR6nzyi/xWrHTvYbL3Oc+aqQ1vgq
	EqwXkSR3nV9HRv53PqonYDc3oUBC1h0z97bB4uuz9OxEAym2zGY=
X-Received: by 2002:a05:690e:150d:b0:650:131b:6ee4 with SMTP id
 956f58d0204a3-6504873abf4mr15220422d50.20.1775555167625; Tue, 07 Apr 2026
 02:46:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <20260402092607.96430-4-laoar.shao@gmail.com>
 <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com>
 <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
 <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
 <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
 <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
 <adQhpBC2W9I6QW-g@redhat.com> <CAPhsuW66tuF+QZ0pVheWb5sC4NQ-9CXikq=zMrPBXTHcsVPjdg@mail.gmail.com>
 <CALOAHbDN_t-ZRO0g9_sQFCv0J6SPDFfwJCcwSzd4ww5XRkU0QA@mail.gmail.com>
In-Reply-To: <CALOAHbDN_t-ZRO0g9_sQFCv0J6SPDFfwJCcwSzd4ww5XRkU0QA@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 7 Apr 2026 17:45:31 +0800
X-Gm-Features: AQROBzD5aJ3floxrTMqD4Z-TWySrLI1f76mfxhJm1yktSWIu7d-2oRdLFdvycRA
Message-ID: <CALOAHbCxPA0dtsx7L2kYn8wwBdM=krZyOpfRTBiDW9qfA_zmzQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
To: Song Liu <song@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, Dylan Hatch <dylanbhatch@google.com>, jpoimboe@kernel.org, 
	jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, kpsingh@kernel.org, 
	mattbobrowski@google.com, jolsa@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	eddyz87@gmail.com, memxor@gmail.com, yonghong.song@linux.dev, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2314-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,google.com,kernel.org,suse.cz,suse.com,goodmis.org,efficios.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 30F6A3AC499
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Apr 7, 2026 at 11:16=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> On Tue, Apr 7, 2026 at 10:54=E2=80=AFAM Song Liu <song@kernel.org> wrote:
> >
> > On Mon, Apr 6, 2026 at 2:12=E2=80=AFPM Joe Lawrence <joe.lawrence@redha=
t.com> wrote:
> > [...]
> > > > > > - The regular livepatches are cumulative, have the replace flag=
; and
> > > > > >   are replaceable.
> > > > > > - The occasional "off-band" livepatches do not have the replace=
 flag,
> > > > > >   and are not replaceable.
> > > > > >
> > > > > > With this setup, for systems with off-band livepatches loaded, =
we can
> > > > > > still release a cumulative livepatch to replace the previous cu=
mulative
> > > > > > livepatch. Is this the expected use case?
> > > > >
> > > > > That matches our expected use case.
> > > >
> > > > If we really want to serve use cases like this, I think we can intr=
oduce
> > > > some replace tag concept: Each livepatch will have a tag, u32 numbe=
r.
> > > > Newly loaded livepatch will only replace existing livepatch with th=
e
> > > > same tag. We can even reuse the existing "bool replace" in klp_patc=
h,
> > > > and make it u32: replace=3D0 means no replace; replace > 0 are the
> > > > replace tag.
> > > >
> > > > For current users of cumulative patches, all the livepatch will hav=
e the
> > > > same tag, say 1. For your use case, you can assign each user a
> > > > unique tag. Then all these users can do atomic upgrades of their
> > > > own livepatches.
> > > >
> > > > We may also need to check whether two livepatches of different tags
> > > > touch the same kernel function. When that happens, the later
> > > > livepatch should fail to load.
>
> That sounds like a viable solution. I'll look into it and see how we
> can implement it.

Does the following change look good to you ?

Subject: [PATCH] livepatch: Support scoped atomic replace using replace tag=
s

Extend the replace attribute from a boolean to a u32 to act as a replace
tag. This introduces the following semantics:

  replace =3D 0: Atomic replace is disabled. However, this patch remains
               eligible to be superseded by others.
  replace > 0: Enables tagged replace (default is 1). A newly loaded
               livepatch will only replace existing patches that share the
               same tag.

To maintain backward compatibility, a patch with replace =3D=3D 0 does not
trigger an outgoing atomic replace, but remains eligible to be superseded
by any incoming patch with a valid replace tag.

Suggested-by: Song Liu <song@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../livepatch/cumulative-patches.rst          | 20 +++++++-----
 Documentation/livepatch/livepatch.rst         | 31 +++++++++++++------
 include/linux/livepatch.h                     |  8 +++--
 kernel/livepatch/core.c                       |  4 +++
 scripts/livepatch/init.c                      |  6 +---
 scripts/livepatch/klp-build                   | 11 +++++--
 6 files changed, 53 insertions(+), 27 deletions(-)

diff --git a/Documentation/livepatch/cumulative-patches.rst
b/Documentation/livepatch/cumulative-patches.rst
index 1931f318976a..06e90dc5967c 100644
--- a/Documentation/livepatch/cumulative-patches.rst
+++ b/Documentation/livepatch/cumulative-patches.rst
@@ -12,23 +12,26 @@ modified the same function in different ways.

 An elegant solution comes with the feature called "Atomic Replace". It all=
ows
 creation of so called "Cumulative Patches". They include all wanted change=
s
-from all older livepatches and completely replace them in one transition.
+from older livepatches with a matching tag and replace them in one transit=
ion.

 Usage
 -----

-The atomic replace can be enabled by setting "replace" flag in struct
klp_patch,
-for example::
+he atomic replace can be enabled by setting a non-zero value to the "repla=
ce"
+attribute in ``struct klp_patch``. This value acts as a **replace tag**,
+defining the scope of the replacement.
+
+For example::

        static struct klp_patch patch =3D {
                .mod =3D THIS_MODULE,
                .objs =3D objs,
-               .replace =3D true,
+               .replace =3D 1,
        };

 All processes are then migrated to use the code only from the new patch.
-Once the transition is finished, all older patches are automatically
-disabled.
+Once the transition is finished, all older patches with the same replace t=
ag
+are automatically disabled. Patches with different tags remain active.

 Ftrace handlers are transparently removed from functions that are no
 longer modified by the new cumulative patch.
@@ -62,9 +65,10 @@ Limitations:
 ------------

   - Once the operation finishes, there is no straightforward way
-    to reverse it and restore the replaced patches atomically.
+    to reverse it and restore the replaced patches (with the same tag)
+    atomically.

-    A good practice is to set .replace flag in any released livepatch.
+    A good practice is to set a consistent .replace tag in related livepat=
ches.
     Then re-adding an older livepatch is equivalent to downgrading
     to that patch. This is safe as long as the livepatches do _not_ do
     extra modifications in (un)patching callbacks or in the module_init()
diff --git a/Documentation/livepatch/livepatch.rst
b/Documentation/livepatch/livepatch.rst
index acb90164929e..1fc1543a22c3 100644
--- a/Documentation/livepatch/livepatch.rst
+++ b/Documentation/livepatch/livepatch.rst
@@ -347,15 +347,28 @@ to '0'.
 5.3. Replacing
 --------------

-All enabled patches might get replaced by a cumulative patch that
-has the .replace flag set.
-
-Once the new patch is enabled and the 'transition' finishes then
-all the functions (struct klp_func) associated with the replaced
-patches are removed from the corresponding struct klp_ops. Also
-the ftrace handler is unregistered and the struct klp_ops is
-freed when the related function is not modified by the new patch
-and func_stack list becomes empty.
+All currently enabled patches may be superseded by a cumulative patch that
+has the ``.replace`` attribute enabled. The behavior of the replacement
+depends on the value assigned to the replace tag:
+
+replace =3D 0
+    Atomic replace is disabled. However, this patch remains eligible to be
+    superseded by others.
+
+replace > 0
+    Enables tagged atomic replace. Once the new patch is enabled and the
+    transition finishes, the livepatching core identifies all existing
+    patches that share the same replace tag.
+
+Once the transition is complete, all functions (``struct klp_func``)
+associated with the matching replaced patches are removed from the
+corresponding ``struct klp_ops``. If a function is no longer modified by
+the new patch and its ``func_stack`` list becomes empty, the ftrace
+handler is unregistered and the ``struct klp_ops`` is freed.
+
+Patches with a different replace tag are not affected by this process
+and remain active. This allows for the independent management and
+stacking of multiple, non-conflicting livepatch sets.

 See Documentation/livepatch/cumulative-patches.rst for more details.

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index ba9e3988c07c..417c67a17b99 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -123,7 +123,11 @@ struct klp_state {
  * @mod:       reference to the live patch module
  * @objs:      object entries for kernel objects to be patched
  * @states:    system states that can get modified
- * @replace:   replace all actively used patches
+ * @replace:   replace tag:
+ *             =3D 0: Atomic replace is disabled; however, this patch rema=
ins
+ *                  eligible to be superseded by others.
+ *             > 0: Atomic replace is enabled. Only existing patches with =
a
+ *                  matching replace tag will be superseded.
  * @list:      list node for global list of actively used patches
  * @kobj:      kobject for sysfs resources
  * @obj_list:  dynamic list of the object entries
@@ -137,7 +141,7 @@ struct klp_patch {
        struct module *mod;
        struct klp_object *objs;
        struct klp_state *states;
-       bool replace;
+       unsigned int replace;

        /* internal */
        struct list_head list;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 28d15ba58a26..e4e5c03b0724 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -793,6 +793,8 @@ void klp_free_replaced_patches_async(struct
klp_patch *new_patch)
        klp_for_each_patch_safe(old_patch, tmp_patch) {
                if (old_patch =3D=3D new_patch)
                        return;
+               if (old_patch->replace && old_patch->replace !=3D
new_patch->replace)
+                       continue;
                klp_free_patch_async(old_patch);
        }
 }
@@ -1194,6 +1196,8 @@ void klp_unpatch_replaced_patches(struct
klp_patch *new_patch)
        klp_for_each_patch(old_patch) {
                if (old_patch =3D=3D new_patch)
                        return;
+               if (old_patch->replace && old_patch->replace !=3D
new_patch->replace)
+                       continue;

                old_patch->enabled =3D false;
                klp_unpatch_objects(old_patch);
diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
index f14d8c8fb35f..cd00e278a1d2 100644
--- a/scripts/livepatch/init.c
+++ b/scripts/livepatch/init.c
@@ -72,11 +72,7 @@ static int __init livepatch_mod_init(void)

        /* TODO patch->states */

-#ifdef KLP_NO_REPLACE
-       patch->replace =3D false;
-#else
-       patch->replace =3D true;
-#endif
+       patch->replace =3D KLP_REPLACE_TAG;

        return klp_enable_patch(patch);

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 7b82c7503c2b..9f6a7673304f 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -118,6 +118,7 @@ Options:
    -j, --jobs=3D<jobs>           Build jobs to run simultaneously
[default: $JOBS]
    -o, --output=3D<file.ko>      Output file [default: livepatch-<patch-na=
me>.ko]
        --no-replace            Disable livepatch atomic replace
+   -t, --replace-tag=3D<tag>     Set the atomic replace tag for this livep=
atch
    -v, --verbose               Pass V=3D1 to kernel/module builds

 Advanced Options:
@@ -142,8 +143,8 @@ process_args() {
        local long
        local args

-       short=3D"hfj:o:vdS:T"
-       long=3D"help,show-first-changed,jobs:,output:,no-replace,verbose,de=
bug,short-circuit:,keep-tmp"
+       short=3D"hfj:o:t:vdS:T"
+       long=3D"help,show-first-changed,jobs:,output:,no-replace,replace-ta=
g:,verbose,debug,short-circuit:,keep-tmp"

        args=3D$(getopt --options "$short" --longoptions "$long" -- "$@") |=
| {
                echo; usage; exit
@@ -176,6 +177,10 @@ process_args() {
                                REPLACE=3D0
                                shift
                                ;;
+                       -t | --replace-tag)
+                               REPLACE=3D"$2"
+                               shift 2
+                               ;;
                        -v | --verbose)
                                VERBOSE=3D"V=3D1"
                                shift
@@ -759,7 +764,7 @@ build_patch_module() {

        cflags=3D("-ffunction-sections")
        cflags+=3D("-fdata-sections")
-       [[ $REPLACE -eq 0 ]] && cflags+=3D("-DKLP_NO_REPLACE")
+       cflags+=3D("-DKLP_REPLACE_TAG=3D$REPLACE")

        cmd=3D("make")
        cmd+=3D("$VERBOSE")


--
Regards
Yafang

