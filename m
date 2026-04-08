Return-Path: <live-patching+bounces-2318-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yILmDznA1Wmi9QcAu9opvQ
	(envelope-from <live-patching+bounces-2318-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 08 Apr 2026 04:40:57 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F3FD93B644F
	for <lists+live-patching@lfdr.de>; Wed, 08 Apr 2026 04:40:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B3A7F301C11A
	for <lists+live-patching@lfdr.de>; Wed,  8 Apr 2026 02:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD96936C9CA;
	Wed,  8 Apr 2026 02:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S58lX8s6"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A38A363093
	for <live-patching@vger.kernel.org>; Wed,  8 Apr 2026 02:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775616049; cv=pass; b=TSBwPiAHujzylpnq7i+02bcq69Ym5IY2G9QtBrscN0YkiU7gmOELXfnGjaG/yx3t3d2CJ2XyUmu16QMaV2clm4QHfTxRMFwn2GDA+DddzQOtWwLSRiHdFaf2fdADJL1EywqzF8dl4vv/HpGmHer40h5SLX4NZkAUApFkrhpFClc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775616049; c=relaxed/simple;
	bh=1RyQFe5Kyzeix//rrB/0IQlX2ISLVCSrxyigLQrsTEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KMNsra/GaEnXjqSUXs0SUjERKir1Mhr3yfaHWUDbkLjSjTtY5MwQvspNJ7eUe4kK3WErL8qHvRKButCUv0sRymHfWwgr0yC2b76kwzBh/oH0ahWF65ZmcMvOLJkMx/BTiyhI3D8c15Rry5V+203kFcdZnIOmR23AjkNjmTjRcd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S58lX8s6; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-65006c99d38so6266741d50.3
        for <live-patching@vger.kernel.org>; Tue, 07 Apr 2026 19:40:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775616047; cv=none;
        d=google.com; s=arc-20240605;
        b=B+JFCo9fXyTwoJP0ULQc+gHuR8WVY3/COMHEltoxVp4ZgkN187QukFeluMbfbgIWya
         NT2XZidDcOuPhSE+EEdzUV/dU2QuDGlOHB9pF96PXOr1LCnWXeMKDXnRatlkDiF2aSJe
         cJm4pJEeVx94f7VPT6QG83JCosdgNvH4BW4zMpFxC48qYx13lMaXvxmPKWBzL9KBGCM7
         +YF0BVVQ9f6rJoLFJJMVUqoAnCSBTwT6AdCCh7AaqGKWWl1iwN52irQYVkc+RvfsMRUc
         qkmN4eQhQjZXKOIfSjNMKtta3yLggjN6wKtx3EWxvVQtV6GfAQLh84HiSZkEAnjbymKT
         jYIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qMla8O/aLGNk5svT1tXJvXj3U+9GiIyir/xJirV0hvA=;
        fh=gKz7fs5C01FbdSyWbxIrImCK1Gs76Td1HnZPA0JJ4xw=;
        b=dLpWiFfOP1AS7eXbe5X+lVLMD56Tfh/RSNwGGAt8h9Mbp2G1G5yaVCAZBzuyaiSMlE
         su9LYxBmllnG49eHn/dBbmGNB0SRrSuavdOIQ/9Ymeht6iljeYMTlLhB38hMc3kKe7M/
         99IDTm5RgsjNZQtyenXB1QHlbwhwaHqBt0xSZNV4o/oEiCzqUfByHyEiUJC8QWoSFtdC
         DNO1q9OcDmh9FTIOlcFfR2SarrU8wW5vYo1nYbLeMuQ6CEUdagKv+7uEvqTkwXHC314Y
         8anW+uHZRWRRiCcBKrMDFtSVIOvK0k5DlCCc3A+Jhtw7ehQjhk/qJjeylifgiRLbx+g8
         VXwQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775616047; x=1776220847; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qMla8O/aLGNk5svT1tXJvXj3U+9GiIyir/xJirV0hvA=;
        b=S58lX8s6GMmk/m+IgTGP/tgOM8bwQdF1b5yrC63U9nl+/HslKU2TrJy2w+HFjuIKig
         zXdYBcvWYR/gM93f//29cWRRPZTSUxKcaB4dS470r2NXElmsUonVXn8yknDDg3d9mVyD
         +dVIB9IXGAQ6ANxa7CCMkX+raXiwGiCfIgACBsbOTwMMD6h0ibZVe2+8EcBFLbJIx3sb
         lqMvrONqSvB8FuWkMYOCWfUccZ63gloZfyIHP8NDb+WqGNt9z2j0WFzF3GBEyAeU4HLv
         sE+rxwd0P5PbqUgnSlwEJmP5RDhwT8TaQOeosxtxqmMi5+oXfQO8ZW5s9tXlP9UJlCSn
         4Hmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775616047; x=1776220847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qMla8O/aLGNk5svT1tXJvXj3U+9GiIyir/xJirV0hvA=;
        b=mmoNVnCkyAkSEzegIXgnB6Bn5ojf2l5+oqUo6+vCQfPfMzil/8azrQajVk2EnK7tlG
         9U4Zb/q03IoMMn00OmPUolMuxxD8MbJfOwRkFIN+0vxmbnIY31BuRrtkcWchtifxXzFH
         ZLTS/5Tmyi/hIpwj9+O/U1ZOzP3GC/j0GepHtLdT0SK2mDKZ6PXd6a0xDgSt2QzzjEN8
         cu+Ofot8lZv38WVbLH76woe8mylIz8nVw5hwBWOa+i4t7m/935zLyUT6VUNyyg0IwZF+
         5l1t9DPochTcsTYVr+2ael3l0fkutesZ046CohWP0LX6hZgRnqdg03/rbUP/vaWFsfsA
         sNmw==
X-Forwarded-Encrypted: i=1; AJvYcCWFo3J9F2JdVwxp3BGPHBhiK6ENTCrKldGR0yjUww8cSg5zBILHw5j+CQVO2axDxsYJPbCbAEbpvIokm9B3@vger.kernel.org
X-Gm-Message-State: AOJu0YyuVgF2vOf2Sc9Ph7Z4PLJEYHIy1ycELux5ObqrTwb1dm8n1RWo
	/vIYGfL5GoTx17jr2+LhswTwCae2cLPAt95xRI60KlRhvsT/sbNzrRGrcFEirV/hMucKMxHZXfW
	en8eD+w7qeV5c3rAGd8g6qxvtgFCeyB4=
X-Gm-Gg: AeBDietGCEVHWBCqUn1+STwiqd7IGzh1WVfBy4/CBwOyp3dZzlzKjiDBLubsZNuL/XD
	a+jL4URWFPkiQSoISPv6sBpV0n0V79Gna4mNHhWC4j3jprMpDcbK11yFG+URWrnanQYi1PovjWm
	jfxIiOQn7IIJjp7T81l1SB4yt36nZl1PjdnvUNsjCqzuZ7v9CXbLif0/aZiVRZN5Qav4ppDmihs
	A8pbhexfFBMTL9tZxYK+y120L3Yvhwh9LUCCkq9zVzuTlrLvZK/64dcASv9Toh8YjRYQRCSM20D
	jak1H0TlCWBN0b92nDwU0ipwvysMNN7R5QtS8xhsfUvlrd5w0a0=
X-Received: by 2002:a05:690e:128c:b0:650:747d:f70f with SMTP id
 956f58d0204a3-650747df9a4mr7606277d50.66.1775616047269; Tue, 07 Apr 2026
 19:40:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-4-laoar.shao@gmail.com> <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com>
 <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
 <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
 <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
 <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
 <adQhpBC2W9I6QW-g@redhat.com> <CAPhsuW66tuF+QZ0pVheWb5sC4NQ-9CXikq=zMrPBXTHcsVPjdg@mail.gmail.com>
 <CALOAHbDN_t-ZRO0g9_sQFCv0J6SPDFfwJCcwSzd4ww5XRkU0QA@mail.gmail.com>
 <CALOAHbCxPA0dtsx7L2kYn8wwBdM=krZyOpfRTBiDW9qfA_zmzQ@mail.gmail.com> <adUd0Mojbtrwmeod@pathway.suse.cz>
In-Reply-To: <adUd0Mojbtrwmeod@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 8 Apr 2026 10:40:10 +0800
X-Gm-Features: AQROBzD7OzdJXLVqfJs5CVSyjbxMY4IuVSSuRahFgmBMCr0BGFPcLQcyfxn3E20
Message-ID: <CALOAHbDG9mq1iJv5suct=cqJ+2r8VvJ-dXN=nuvMw0XYqnUjxA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
To: Petr Mladek <pmladek@suse.com>
Cc: Song Liu <song@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, 
	Dylan Hatch <dylanbhatch@google.com>, jpoimboe@kernel.org, jikos@kernel.org, 
	mbenes@suse.cz, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org, mattbobrowski@google.com, 
	jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, 
	yonghong.song@linux.dev, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2318-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,redhat.com,google.com,suse.cz,goodmis.org,efficios.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RSPAMD_EMAILBL_FAIL(0.00)[laoarshao.gmail.com:query timed out];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: F3FD93B644F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Apr 7, 2026 at 11:08=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Tue 2026-04-07 17:45:31, Yafang Shao wrote:
> > On Tue, Apr 7, 2026 at 11:16=E2=80=AFAM Yafang Shao <laoar.shao@gmail.c=
om> wrote:
> > >
> > > On Tue, Apr 7, 2026 at 10:54=E2=80=AFAM Song Liu <song@kernel.org> wr=
ote:
> > > >
> > > > On Mon, Apr 6, 2026 at 2:12=E2=80=AFPM Joe Lawrence <joe.lawrence@r=
edhat.com> wrote:
> > > > [...]
> > > > > > > > - The regular livepatches are cumulative, have the replace =
flag; and
> > > > > > > >   are replaceable.
> > > > > > > > - The occasional "off-band" livepatches do not have the rep=
lace flag,
> > > > > > > >   and are not replaceable.
> > > > > > > >
> > > > > > > > With this setup, for systems with off-band livepatches load=
ed, we can
> > > > > > > > still release a cumulative livepatch to replace the previou=
s cumulative
> > > > > > > > livepatch. Is this the expected use case?
> > > > > > >
> > > > > > > That matches our expected use case.
> > > > > >
> > > > > > If we really want to serve use cases like this, I think we can =
introduce
> > > > > > some replace tag concept: Each livepatch will have a tag, u32 n=
umber.
> > > > > > Newly loaded livepatch will only replace existing livepatch wit=
h the
> > > > > > same tag. We can even reuse the existing "bool replace" in klp_=
patch,
> > > > > > and make it u32: replace=3D0 means no replace; replace > 0 are =
the
> > > > > > replace tag.
> > > > > >
> > > > > > For current users of cumulative patches, all the livepatch will=
 have the
> > > > > > same tag, say 1. For your use case, you can assign each user a
> > > > > > unique tag. Then all these users can do atomic upgrades of thei=
r
> > > > > > own livepatches.
> > > > > >
> > > > > > We may also need to check whether two livepatches of different =
tags
> > > > > > touch the same kernel function. When that happens, the later
> > > > > > livepatch should fail to load.
>
> I still think how to make the hybrid mode more secure:
>
>     + The isolated sets of livepatched functions look like a good rule.
>     + What about isolating the shadow variables/states as well?

We might consider extending the klp_shadow_* API to support the new
livepatch tag.

>
> > > That sounds like a viable solution. I'll look into it and see how we
> > > can implement it.
> >
> > Does the following change look good to you ?
> >
> > Subject: [PATCH] livepatch: Support scoped atomic replace using replace=
 tags
> >
> > Extend the replace attribute from a boolean to a u32 to act as a replac=
e
> > tag. This introduces the following semantics:
> >
> >   replace =3D 0: Atomic replace is disabled. However, this patch remain=
s
> >                eligible to be superseded by others.
> >   replace > 0: Enables tagged replace (default is 1). A newly loaded
> >                livepatch will only replace existing patches that share =
the
> >                same tag.
> >
> > To maintain backward compatibility, a patch with replace =3D=3D 0 does =
not
> > trigger an outgoing atomic replace, but remains eligible to be supersed=
ed
> > by any incoming patch with a valid replace tag.
> >
> > diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> > index ba9e3988c07c..417c67a17b99 100644
> > --- a/include/linux/livepatch.h
> > +++ b/include/linux/livepatch.h
> > @@ -123,7 +123,11 @@ struct klp_state {
> >   * @mod:       reference to the live patch module
> >   * @objs:      object entries for kernel objects to be patched
> >   * @states:    system states that can get modified
> > - * @replace:   replace all actively used patches
> > + * @replace:   replace tag:
> > + *             =3D 0: Atomic replace is disabled; however, this patch =
remains
> > + *                  eligible to be superseded by others.
>
> This is weird semantic. Which livepatch tag would be allowed to
> supersede it, please?
>
> Do we still need this category?

It can be superseded by any livepatch that has a non-zero tag set.

This ensures backward compatibility: while a non-atomic-replace
livepatch can be superseded by an atomic-replace one, the reverse is
not permitted=E2=80=94an atomic-replace livepatch cannot be superseded by a
non-atomic one.

>
> > + *             > 0: Atomic replace is enabled. Only existing patches w=
ith a
> > + *                  matching replace tag will be superseded.
> >   * @list:      list node for global list of actively used patches
> >   * @kobj:      kobject for sysfs resources
> >   * @obj_list:  dynamic list of the object entries
> > @@ -137,7 +141,7 @@ struct klp_patch {
> >         struct module *mod;
> >         struct klp_object *objs;
> >         struct klp_state *states;
> > -       bool replace;
> > +       unsigned int replace;
>
> This already breaks the backward compatibility

It doesn't break backward compatibility.

> by changing the type
> and semantic of this field. I would also change the name to better
> match the new semantic. What about using:
>
>
>   * @replace_set: Livepatch using the same @replace_set will get
>                 atomically replaced, see also conflicts[*].
>
>         unsigned int replace_set;
>
> [*] A livepatch module, livepatching an already livepatches function,
>     can be loaded only when it has the same @replace_set number.
>
>     By other words, two livepatches conflict when they have a different
>     @replace_set number and have at least one livepatched version
>     in common.

Renaming it to @replace_set makes sense to me.

>
> >
> >         /* internal */
> >         struct list_head list;
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 28d15ba58a26..e4e5c03b0724 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -793,6 +793,8 @@ void klp_free_replaced_patches_async(struct
> > klp_patch *new_patch)
> >         klp_for_each_patch_safe(old_patch, tmp_patch) {
> >                 if (old_patch =3D=3D new_patch)
> >                         return;
> > +               if (old_patch->replace && old_patch->replace !=3D
> > new_patch->replace)
> > +                       continue;
> >                 klp_free_patch_async(old_patch);
> >         }
> >  }
> > @@ -1194,6 +1196,8 @@ void klp_unpatch_replaced_patches(struct
> > klp_patch *new_patch)
> >         klp_for_each_patch(old_patch) {
> >                 if (old_patch =3D=3D new_patch)
> >                         return;
> > +               if (old_patch->replace && old_patch->replace !=3D
> > new_patch->replace)
> > +                       continue;
> >
> >                 old_patch->enabled =3D false;
> >                 klp_unpatch_objects(old_patch);
>
> This handles only the freeing part. More changes will be
> necessary:
>
>    + klp_is_patch_compatible() must check also conflicts
>      between livepatches with different @replace_set.
>      The conflicts might be in the lists of:
>
>         + livepatched functions
>         + state IDs (aka callbacks and shadow variables IDs)
>
>    + klp_add_nops() must skip livepatches with another @replace_set
>
>    + klp_unpatch_replaced_patches() should unpatch only
>      patches with the same @replace_set

I appreciate the guidance on this.

>
> Finally, we would need to update existing selftests
> plus add new selftests.
>
> It is possible that I have missed something.
>
> Anyway, you should wait for more feedback before you do too much
> coding, especially the selftests are not needed at RFC stage.

Sure.

--=20
Regards
Yafang

