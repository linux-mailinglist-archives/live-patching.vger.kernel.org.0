Return-Path: <live-patching+bounces-2894-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ePrBAh1ZFmo9lgcAu9opvQ
	(envelope-from <live-patching+bounces-2894-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 04:38:21 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7156B5DE9DC
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 04:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3DD3B300A3BB
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 02:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1FE027A477;
	Wed, 27 May 2026 02:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R3WmGfcP"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50811F3B85
	for <live-patching@vger.kernel.org>; Wed, 27 May 2026 02:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779849495; cv=pass; b=IgAPSXvto2gTZQfN+dz6LPUsLuUb+BW4tWaGq9XpbgxR26cj4eznZRtFK/z4gWibUuCUm8+9bxOUdCEw3fM82JJ/ynTVXjxGfiZOwfKJ0h8wn+c/G9J66K8I+0YaPNYCVzgyvfjA7Gt/Bif/Vj4sZtFJjj8rGTFfD72gviXZc/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779849495; c=relaxed/simple;
	bh=AFyi4zswWRbg6/9m0Y7XCaLhh/tm7PUSWmCgSaT095A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nP7OQ9boA9mLBWPKsauzxj2ZUwRwq4vAPut5s6atI/9MwwvRYMLa7AdGia0I7RGQbsu98CEn+AqxU/u1AtG7nZiENactNot0+asUo8v8Vt8f3h97hxmG/kmjP/KQa7Uy6YoVLwYP6DQn1nn0MRYfN2JcismNoNeK3YbcLjA6MoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R3WmGfcP; arc=pass smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7bf1eaba464so104665677b3.1
        for <live-patching@vger.kernel.org>; Tue, 26 May 2026 19:38:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779849493; cv=none;
        d=google.com; s=arc-20240605;
        b=GlMH1Lk4OSGRbI5pesQOUAE0XNG3ZJWx1HiRbYf1peIU8VY3JX+kzexDqxxWSkhWAP
         k/lolpJK0Vyp4aqjoW0S89XmSrcL8DuGh8+7ZLMZi4Nrq0PPEhdpW1CMAQNbJ918x0Wq
         kPAWb32MVmwYsaz+wDVFmZn8CGhB/mbwDFUouD4RnHlhdrWkYnJDV8zVJk+cULScA1rm
         yqaeIR3pNEButs4bjIY4I1WbIbj/VAgd5dpPjAvXFlkonUB2F9CEwDG4vOGbWndc9v0D
         Qb0tXyhHp9KUUVMI7abgubi7/JyADLfqVElqecSYsETGtbD74HNX2dI9A6NKk7Bu6eF/
         lcOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JJZy3KVIs++6hlXGT4FpG8R12Qy96SPcU3we7qYdxwg=;
        fh=yz8gTQ2BgQTxRUrWuMFRF3C1MuJ70LhsaMbeV9ehCuM=;
        b=cp6sdbpFBw81hKstaMqbd4gEh5TW+smCMzJZOxAS0g2NRawEfMNUEjYhQO8rFfk6z+
         3uTE/PUARW6ONykY5x6kAM+YqzdfRF9K5chOhG4To1lGzLDzhm7uFSvQ2R7ZqEOytcwb
         kpAtzQhXDAZfBXA4fgxO17jKP8JSKnyrx41faKASssbutpyFtFOBP+myKJOfgpGdo/SH
         kFKIM44cyh0B+MvOxIaRMkW+vjFbahJdp3vXY2ogzHyMQ36kToidf5FvLSV4pfn98gWV
         kY8NN02KgWlusAvzE81hqCiwDZbCOKirjKoXBRiOJ/h0OF5bbCNhv/nyHXvdjoVfL3au
         f+7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779849493; x=1780454293; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJZy3KVIs++6hlXGT4FpG8R12Qy96SPcU3we7qYdxwg=;
        b=R3WmGfcPuD+HqcWBoaaSFgqR2QD+SnlBoACahjzLTkphPX9yOv9TkqkE+nYVtBBiv8
         RcsqDoorJE6+QO2Jyt/gEEsBYZoMt3bIo/NtJ7VbBHcvhAD/8cbgvBcMTdr/HAtpjbOh
         jHFIs6GsCFK+X51JM4+U24ce45hEo70Sw8EQQuASsaK6rOqZQHjzgVs0UtXU0eW0//BX
         XxI4i8l9InEBrmOpw8rP9w07ALlM6yrqiGrcwBDTMGA8jMQNPZH7SV47/6m07Eo+iGwh
         ZL8j6X0+OJ3zm61AR2Ei+2LpmH0y7hqwOLypm1BLk5sD6xkCqFKLIAMnEuPKoJAeCY8q
         YTcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779849493; x=1780454293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JJZy3KVIs++6hlXGT4FpG8R12Qy96SPcU3we7qYdxwg=;
        b=siMeHrMxyb75+/hK7nWI0N76s5o/LFB+b6EAOL62g1lq4SEb2wCvDMTgsQs6MXw/TS
         eCM3OYgKVM3DM6t7yd9gwwB/JbPBiwYul9WB/fwvLc5fWmqTmWbrkWkCqAVE0csgIa4C
         qVsMZU0WoYRlCq/oHvIbBnY2sSIPY3jqM0eQLEDoyyeBn/JY4Czn+pXOhsVUKhDzHawC
         /a3+qLNjgJIJ3Y+wOTD/pLF0f542KoUoPCt/la+aLY2KZSfkFrCV9dxhrufEdy6uBZmd
         J3+/NUWxYKn41A0jIjjYUs9I7B5lpQTr9Xt4fbM5mR1thFARwc7UUoSNs/FhN0iEVOjo
         0Cyw==
X-Forwarded-Encrypted: i=1; AFNElJ/MP7uuUfVzIBbV1Rddc5mYY+/e5hNhUGMwL/Kt4Q/ktg2A9feXRQqz9griONrzz8IPmp4MhSbDf2vO+C93@vger.kernel.org
X-Gm-Message-State: AOJu0Yygo+3eMCBNBy3D1d+FCKpjvb9Qg4BpFiABLdKIJSnGe2N8jP04
	dPcvLgNVgwik2MmQd/yRDPRYvC0+UB7QvgSHboB+dRA3/wYQ9stvIRMEaltFUB0avBEW2lNJWBt
	DV1aY55WgKVIj4GEVPTu0ZeJkXTLzPJo=
X-Gm-Gg: Acq92OE6FxaEz4DJ6gGcDRqtiQoaFt86rEymiiqCUGZND+oNT7LT/zyJ8IAuxF09gRE
	edc12oMxdMaYu6hUiPXXWisUZWtVPYXHBEHds3qVihdBKvZKOOZHrpoIwnHFxwelmjBDPfzYCme
	YNvR+qIPsUio+MMkdm5GKgxpnGh2edMbN4kmibosFT4MoOguFJg3K5yBPd7dmpoxR4cJegVs3FP
	vTcr+t8mfI09P+2JQld96BElN5HePds5eoLEvg9RtH+ho5MDMYdW0LGFuap9zf8fHtTRrzy4qas
	kSbNa6e5eI3f2QL2rUlI23YSxuAU77tfMiGDEbTTHQXVtL6tb7c=
X-Received: by 2002:a05:690c:c4c2:b0:7d0:2b7:6b16 with SMTP id
 00721157ae682-7d336cb4552mr229400117b3.46.1779849492752; Tue, 26 May 2026
 19:38:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513143321.26185-1-laoar.shao@gmail.com> <20260513143321.26185-2-laoar.shao@gmail.com>
 <ahWXfHRFpvQBWgsa@pathway.suse.cz>
In-Reply-To: <ahWXfHRFpvQBWgsa@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 27 May 2026 10:37:36 +0800
X-Gm-Features: AVHnY4IeGbCbHI1UCsxLEFpi4I7KRS8eV-E0qk6Dzw6LSs-3n1ILvEEKqjMq5go
Message-ID: <CALOAHbDFqOF5KkkARbUCBZ4RsQEbCcjjMUt2qTm+fGLWWaubvA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] livepatch: Support scoped atomic replace using
 replace set
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, song@kernel.org, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2894-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.com:email]
X-Rspamd-Queue-Id: 7156B5DE9DC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, May 26, 2026 at 8:52=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Wed 2026-05-13 22:33:16, Yafang Shao wrote:
> > Convert the replace attribute from a boolean to a u32 to function as a
> > "replace set." A newly loaded livepatch will now atomically replace
> > existing patches that belong to the same set.
> >
> > This change currently supports function replacement only; support for
> > state and shadow variables will be introduced in subsequent patches.
> >
> > --- a/Documentation/livepatch/cumulative-patches.rst
> > +++ b/Documentation/livepatch/cumulative-patches.rst
> > @@ -17,18 +17,20 @@ from all older livepatches and completely replace t=
hem in one transition.
> >  Usage
> >  -----
> >
> > -The atomic replace can be enabled by setting "replace" flag in struct =
klp_patch,
> > -for example::
> > +The "replace_set" attribute in ``struct klp_patch`` acts as a **replac=
e set**,
> > +defining the scope of the replacement. By default, the replace set is =
1.
>
> Why "1" by default, please?
>
> I guess that you wanted to make it "compatible" with the original
> "replace" flag. It makes some sense. But it is weird in the long term.
>
> This patchset is changing the whole semantic. Every livepatch is able
> to replace an older one. It is not longer "no replace" vs "replace
> all". Instead, a livepatch with a particular "replace_set" number
> replaces an older livepatch with the same "replace_set" number.
>
> It brings the question whether "replace_set" is a good name. There
> is always only one enabled livepatch with a particular "replace_set"
> number. It would make sense to call it "replace_tag" or "replace_id".
>
> That said, the "set" might mean a set of livepatched functions.
> And we should make sure that each set is separate. We should refuse
> loading a livepatch which would patch a function already patched
> by another livepatch with another another "replace_set".
>
> Summary:
>
> I would keep "replace_set" name. But I would use "0" by default.

I will update it.

>
> > +For example::
> >
> >       static struct klp_patch patch =3D {
> >               .mod =3D THIS_MODULE,
> >               .objs =3D objs,
> > -             .replace =3D true,
> > +             .replace_set =3D 1,
> >       };
> >
> >  All processes are then migrated to use the code only from the new patc=
h.
> > -Once the transition is finished, all older patches are automatically
> > -disabled.
> > +Once the transition is finished, all older patches with the same repla=
ce
> > +set are automatically disabled. Patches with different tags remain act=
ive.
> >
> >  Ftrace handlers are transparently removed from functions that are no
> >  longer modified by the new cumulative patch.
> > @@ -62,9 +64,10 @@ Limitations:
> >  ------------
> >
> >    - Once the operation finishes, there is no straightforward way
> > -    to reverse it and restore the replaced patches atomically.
> > +    to reverse it and restore the replaced patches (with the same set)
> > +    atomically.
> >
> > -    A good practice is to set .replace flag in any released livepatch.
> > +    A good practice is to set a consistent .replace set in related liv=
epatches.
>
> I would say something like:
>
>      "A good practice is to use only one (default) "replace_set". It
>      makes sure that there always will be only one enabled livepatch
>      on the system. The consistency model will ensure a safe update
>      between two versions. It prevents potential problems with installing
>      two livepatches doing incompatible functional changes."

Thanks for your suggestion.

>
> >      Then re-adding an older livepatch is equivalent to downgrading
> >      to that patch. This is safe as long as the livepatches do _not_ do
> >      extra modifications in (un)patching callbacks or in the module_ini=
t()
> > diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/live=
patch/livepatch.rst
> > index acb90164929e..07c8d5a13003 100644
> > --- a/Documentation/livepatch/livepatch.rst
> > +++ b/Documentation/livepatch/livepatch.rst
> > @@ -347,15 +347,20 @@ to '0'.
> >  5.3. Replacing
> >  --------------
> >
> > -All enabled patches might get replaced by a cumulative patch that
> > -has the .replace flag set.
> > -
> > -Once the new patch is enabled and the 'transition' finishes then
> > -all the functions (struct klp_func) associated with the replaced
> > -patches are removed from the corresponding struct klp_ops. Also
> > -the ftrace handler is unregistered and the struct klp_ops is
> > -freed when the related function is not modified by the new patch
> > -and func_stack list becomes empty.
> > +All currently enabled patches may be superseded by a cumulative patch =
that
>
> In fact, there always can be only one livepatch with a given
> "replace_set" number. They always replace each other.

Thanks for the clarification.

>
> > +has the same ``.replace_set`` attribute. Once the new patch is enabled=
 and
> > +the transition finishes, the livepatching core identifies all existing
> > +patches that share the same replace set.
> > +
> > +Once the transition is complete, all functions (``struct klp_func``)
> > +associated with the matching replaced patches are removed from the
> > +corresponding ``struct klp_ops``. If a function is no longer modified =
by
> > +the new patch and its ``func_stack`` list becomes empty, the ftrace
> > +handler is unregistered and the ``struct klp_ops`` is freed.
> > +
> > +Patches with a different replace set are not affected by this process
> > +and remain active. This allows for the independent management and
> > +stacking of multiple, non-conflicting livepatch sets.
> >
> >  See Documentation/livepatch/cumulative-patches.rst for more details.
> >
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -454,7 +454,7 @@ static ssize_t replace_show(struct kobject *kobj,
>
> The function should get renamed to replace_set_show()...

sure.

>
> >       struct klp_patch *patch;
> >
> >       patch =3D container_of(kobj, struct klp_patch, kobj);
> > -     return sysfs_emit(buf, "%d\n", patch->replace);
> > +     return sysfs_emit(buf, "%d\n", patch->replace_set);
> >  }
> >
> >  static ssize_t stack_order_show(struct kobject *kobj,
> > --- a/kernel/livepatch/state.c
> > +++ b/kernel/livepatch/state.c
> > @@ -85,24 +85,25 @@ EXPORT_SYMBOL_GPL(klp_get_prev_state);
> >
> >  /* Check if the patch is able to deal with the existing system state. =
*/
> >  static bool klp_is_state_compatible(struct klp_patch *patch,
> > +                                 struct klp_patch *old_patch,
> >                                   struct klp_state *old_state)
> >  {
> >       struct klp_state *state;
> >
> >       state =3D klp_get_state(patch, old_state->id);
> >
> > -     /* A cumulative livepatch must handle all already modified states=
. */
> > +     /*
> > +      * If the new livepatch shares a state set with an existing one, =
it
> > +      * must maintain compatibility with all states modified by the ol=
d
> > +      * patch.
> > +      */
> >       if (!state)
> > -             return !patch->replace;
> > +             return patch->replace_set !=3D old_patch->replace_set;
>
>
> >       return state->version >=3D old_state->version;
>
> Also I would enforce that two livepatches with a different "replace_set"
> must _not_ use the same "state->id".

I will update it.

>
> >  }
> >
> > -/*
> > - * Check that the new livepatch will not break the existing system sta=
tes.
> > - * Cumulative patches must handle all already modified states.
> > - * Non-cumulative patches can touch already modified states.
> > - */
> > +/* Check that the new livepatch will not break the existing system sta=
tes. */
> >  bool klp_is_patch_compatible(struct klp_patch *patch)
> >  {
> >       struct klp_patch *old_patch;
> > @@ -110,7 +111,7 @@ bool klp_is_patch_compatible(struct klp_patch *patc=
h)
> >
> >       klp_for_each_patch(old_patch) {
> >               klp_for_each_state(old_patch, old_state) {
> > -                     if (!klp_is_state_compatible(patch, old_state))
> > +                     if (!klp_is_state_compatible(patch, old_patch, ol=
d_state))
> >                               return false;
> >               }
> >       }
>
> In addition, I strictly recommend to compare the set of livepatched
> functions. We should refuse loading a livepatch which would want to modif=
y
> a function which is already livepatched with the livepatch with
> another "replace_set".

I will update it.

>
> Aka, the "set" means a set of livepatched functions. And the sets
> should be independent.
>
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -720,11 +720,11 @@ void klp_force_transition(void)
> >               klp_update_patch_state(idle_task(cpu));
> >
> >       /* Set forced flag for patches being removed. */
> > -     if (klp_target_state =3D=3D KLP_TRANSITION_UNPATCHED)
> > +     if (klp_target_state =3D=3D KLP_TRANSITION_UNPATCHED) {
> >               klp_transition_patch->forced =3D true;
> > -     else if (klp_transition_patch->replace) {
> > +     } else {
> >               klp_for_each_patch(patch) {
> > -                     if (patch !=3D klp_transition_patch)
> > +                     if (patch->replace_set =3D=3D klp_transition_patc=
h->replace_set)
>
> We still need to skip klp_transition patch as suggested by Sashiko AI.

sure

>
> >                               patch->forced =3D true;
> >               }
> >       }
> > --- a/scripts/livepatch/init.c
> > +++ b/scripts/livepatch/init.c
> > @@ -72,12 +72,7 @@ static int __init livepatch_mod_init(void)
> >
> >       /* TODO patch->states */
> >
> > -#ifdef KLP_NO_REPLACE
> > -     patch->replace =3D false;
> > -#else
> > -     patch->replace =3D true;
> > -#endif
> > -
> > +     patch->replace_set =3D KLP_REPLACE_TAG;
>
> It should be KLP_REPLACE_SET to keep the naming consistent.

I will fix it.

>
> Is KLP_REPLACE_SET always defined, please?

Right, it is always defined:

  cflags+=3D("-DKLP_REPLACE_SET=3D$REPLACE")

>
> >       return klp_enable_patch(patch);
> >
> >  err_free_objs:
> > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > index 7b82c7503c2b..66d4a0631f1b 100755
> > --- a/scripts/livepatch/klp-build
> > +++ b/scripts/livepatch/klp-build
> > @@ -172,9 +172,9 @@ process_args() {
> >                               NAME=3D"$(module_name_string "$NAME")"
> >                               shift 2
> >                               ;;
> > -                     --no-replace)
> > -                             REPLACE=3D0
> > -                             shift
> > +                     -s | --replace-set)
> > +                             REPLACE=3D"$2"
>
> I would rename it to REPLACE_SET.

sure

>
> > +                             shift 2
> >                               ;;
> >                       -v | --verbose)
> >                               VERBOSE=3D"V=3D1"
> > @@ -759,7 +759,7 @@ build_patch_module() {
> >
> >       cflags=3D("-ffunction-sections")
> >       cflags+=3D("-fdata-sections")
> > -     [[ $REPLACE -eq 0 ]] && cflags+=3D("-DKLP_NO_REPLACE")
> > +     cflags+=3D("-DKLP_REPLACE_TAG=3D$REPLACE")
>
> with a consisten naming scheme:
>
>         cflags+=3D("-DKLP_REPLACE_SET=3D$REPLACE_SET")
>
> Is there a default value?

The default value is currently 1, but I will update it to 0 as suggested.

  REPLACE=3D1

>
>
> >       cmd=3D("make")
> >       cmd+=3D("$VERBOSE")
>
>
> In general, I am fine with this change. Well, it would require also
> adding/fixing selftests.

I will update it.

>
> That said, I would prefer to rework the klp callbacks, shadow, and
> state API first. But it is not a strict requirement.

I will submit this as a standalone patch, as function replacement
works seamlessly with it.

--=20
Regards
Yafang

