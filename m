Return-Path: <live-patching+bounces-2863-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6F5SFlQLDGo5UQUAu9opvQ
	(envelope-from <live-patching+bounces-2863-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 09:03:48 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6EBE578952
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 09:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5C628308B98E
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 06:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EEE6366563;
	Tue, 19 May 2026 06:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ikPRbpbZ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78092377ED7
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 06:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173834; cv=pass; b=FDmW7R2EfRfIhbrXLbBdhsfUcXtl8jfqbAeaaIZ9JgRqzUcqbjL3PrPiVHko5ud4cSzJ9f+BlQQKatTZzGy2k9QqCIVrBfCUXdu/3SIVdkcTtfAzzoC/0wT+KRcQ8Ti4v3t3WelvXJn20hbPBgBM9OV/ZcIBQf+MW288wlLvVRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173834; c=relaxed/simple;
	bh=OwxHlPGz5ECvvbPqp96QaRuFid/aSDuMfJI5ko53EyE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aVBQBlt4bT728nKkQPBYlNDqwujxTwwvy/TONio7u+XN8ezXu6zsBKknNBafdWYeMZz0A0GrKxeCIrq/9n6fXxweCxgdrdUlaQNTPgpeGOmTh4lOatrSzrKSsRf+QZOPhxZWbgpslmKwwrLzE78C5aKi73FFz9mP7H9uCPz+qio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ikPRbpbZ; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7bd4c61765dso26648127b3.3
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:57:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779173831; cv=none;
        d=google.com; s=arc-20240605;
        b=I5t0lCrn7lzcHoEw+dMSfOvwKQrkjRR8WyVmKgmEA1iZYs6y7HdD1FEq2Z3yQXlZy3
         N3rghVbqRHQipBCNZBU8e1xVhXjKLcf1NR8xZq0PfkkUdINUgiaYe/YK+QtkzqOA2x0n
         DO1nQh3jRj07La7IrjVb58//Z1N3wnpXtX0Hj/PW0W7AbbfraUWMgUw04ergaJWl1MFI
         Oy1yFpQ3/A4Gd4doV/JNU9ZUhR24RE6+AT08Hb7tARnEl6xodW+viwZrXT3e3LNcMBMS
         WgbZB9k50OLOgeqsR0+dCaBgdMrBwx3ZXq7WNwnjUfKPNm8jSFBDi+Q6xzVtkQ/wXPlg
         R4dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6YzJyV+bO2QFVkrxFi/2ouYgMlXUGJCU36KJo4L5Lf4=;
        fh=2pfQtjj6JYI88ZV9C3oOEgf+jbZQEqyy0E9cDTbZ0S0=;
        b=dxqjB82j44yY2ddRKgCCY+zO/Uawyv3mIkYjlV9wtrAHg1knKhzK7LsDW47Esbj6wl
         YiBfDtHaQbiOc7737AlNh+hzQMeUgJDYjBxt4JmCaCwUsS6FOU1+hQtHD8hCzcdD1tbM
         yjazbwt7F+FJCGLFxVx7RrdmsFCC6NYOOAz50Yms6GazkAQ24Vs+aiKEIwr18q9cx9vq
         kZgi1Iz4f28LlF07pDU/YOPwCiq/vwIA47uR4IJTUGWZfsW7qePYI2WwQLcAQuDfHCOw
         78JCyrjUhV/xPBAz+z6YCEo79AuGeOHYCBs6/D+qvVs2nyjyqeAUqvP0CyoC8OrfsPBw
         wbrA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779173831; x=1779778631; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6YzJyV+bO2QFVkrxFi/2ouYgMlXUGJCU36KJo4L5Lf4=;
        b=ikPRbpbZiPnsBz8oFZjh4eui6T3kJU74rbTBaHu2KHY0mLzMrzb6H77TL9hVYQDN8L
         ogTslqR5BpqfybhtoUzO5tLTQlGvCxCdabFvwHLwvawKMrCiz8tIK+ngVxxYULp0fRw+
         /k6SaMEnh7NmOutf11sAVECMrBE0y0aMvztTxGQ3GotG3jLEPeOUQdiXFeY/kA/sFfeS
         mIwBHkTuj6ItL8wNR0VsDsgqNO1yJ84+i6bAKTp1s211EWold3CSHYDKeNRfAyCuo7j4
         wBurf5jcAOWS1GEwCDh8a1W37b0ngNJWDQbJwA0uHOpzTmXDLeTL0Ixf7qY/gj7cpPma
         0qYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173831; x=1779778631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6YzJyV+bO2QFVkrxFi/2ouYgMlXUGJCU36KJo4L5Lf4=;
        b=FZW3HFIRcnNIzD/V4p4rnLHla9G1n4imX+MtcO4gg8tO8YSCR+i2OUFrJ2he9kykFW
         Bwj0BHsoHCT1QEDLsPJXLGX07sliCVAE9pGpjXJl2qD5Dt7f312OiaKLgBZlSK5ma4ui
         kK9dKlBaoukKebALAYlKsX8X9l0HmP95mFd/3RISL8VpAY1Su3231/6T+9n587OZZHNx
         ySM9QxipDTjvgCSkJXOpugY3R8ESdpmoMNGXkMUkGfe91d4RLNz30OjmnzjSdoKSiQTT
         XYIVmWmSYbcQUabLwz8tp6ad9tB2BcKb7s2Evl3OhyTarIMHr2RsIUeyprEhzNLzl1jP
         G6nQ==
X-Forwarded-Encrypted: i=1; AFNElJ/4vxoYE+/aKe40OSlsL0aYbb2Zta8j6CyTujBiAJe7YvLcydcCbV9Lr0+LoIyDbu5Rl/WREJfQsZz81LQ7@vger.kernel.org
X-Gm-Message-State: AOJu0YzWWP8d0GqkEU384t2RwEQu0YXOaV67+uFZzSh6O7lnMsJkQig4
	VHqDNGgDGZaY11nSiscFJDOIRDM5spzmNr9+MUo+1oss6gttsPYiLzIw34snHEup2DEnWlo7aWx
	NS6gnSQW1lkErOFCq45iOZDbnFn5qxwc=
X-Gm-Gg: Acq92OFA4sl9EZ4xsTeuJbSDDOTMC36AlpoObX2cGbgJ0q8m4M4/5zqeDm6oKuS4q8C
	WJ6bbQoTxQurU5BpaWRa2dck6lXQRmnbPgOkgr/JHrufNnkMW194tOlWLR+M7Ci5aVZa9GRIZLb
	z2/s7PiJ/yAGL5v9kxxRT+r3fFbtbe6z7KkKvVP3yOf3O3wHFLM6Sfiq2lteaQeWxZGes/RLee0
	h4CBjJerLnFn1GP3qZk6Be5pf1pR8yWhCnE+5nncsUSNEaO1SHtpgMgSc1YB9WjX9Dnq6rYf7OI
	OaQUPJGtpxJtdyqqWaoVKJ/chZ7AnL9fn+g8au4CynkzL7ndVwM=
X-Received: by 2002:a05:690c:c248:b0:79f:4e02:50cc with SMTP id
 00721157ae682-7c95c7f00famr211146907b3.42.1779173831407; Mon, 18 May 2026
 23:57:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513143321.26185-7-laoar.shao@gmail.com> <20260514230124.A4236C2BCB3@smtp.kernel.org>
In-Reply-To: <20260514230124.A4236C2BCB3@smtp.kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 19 May 2026 14:56:35 +0800
X-Gm-Features: AVHnY4JvYrg93B2o6rxhprK1XxGcjfdc28pes5tYsAu0IfXgVN0YjAMMBbz2omY
Message-ID: <CALOAHbB_94VGGEmXrSN9dckqNHZdQDv0ZbH0xkuA6ri+g9=MWA@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] livepatch: Support replace_set in shadow variable API
To: sashiko-reviews@lists.linux.dev
Cc: jpoimboe@kernel.org, joe.lawrence@redhat.com, song@kernel.org, 
	mbenes@suse.cz, jikos@kernel.org, pmladek@suse.com, 
	live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2863-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[gmail.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,sashiko.dev:url]
X-Rspamd-Queue-Id: A6EBE578952
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, May 15, 2026 at 7:01=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 4 potential issu=
e(s) to consider:
> - [High] Newly allocated shadow variables fail to store the `replace_set`=
 identifier, breaking all subsequent lookups and leading to unbounded memor=
y leaks.
> - [High] The `klp_shadow_combined_id()` function invokes undefined behavi=
or and loses data on 32-bit architectures by shifting a 32-bit integer by 3=
2 bits.
> - [High] Changing the shadow API `id` parameter to `unsigned int` silentl=
y truncates 64-bit `klp_state` identifiers, leading to memory leaks.
> - [Low] Modifying the `klp_shadow_*` function signatures breaks the build=
 for in-tree callers.
> --
>
> commit 91116e31e667d0beea437b5048ab5a62099a5eed
> Author: Yafang Shao <laoar.shao@gmail.com>
>
> livepatch: Support replace_set in shadow variable API
>
> To support more complex livepatching scenarios where multiple
> replacement sets might coexist, extend the klp_shadow API to
> include a replace_set identifier.
>
> > diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> > index c9f2036dfefcf..cee35f5cae9ad 100644
> > --- a/include/linux/livepatch.h
> > +++ b/include/linux/livepatch.h
> > @@ -192,15 +192,17 @@ static inline bool klp_have_reliable_stack(void)
> >              IS_ENABLED(CONFIG_HAVE_RELIABLE_STACKTRACE);
> >  }
> >
> > -void *klp_shadow_get(void *obj, unsigned long id);
> > -void *klp_shadow_alloc(void *obj, unsigned long id,
> > +void *klp_shadow_get(void *obj, unsigned int replace_set, unsigned int=
 id);
> > +void *klp_shadow_alloc(void *obj, unsigned int replace_set, unsigned i=
nt id,
> >                      size_t size, gfp_t gfp_flags,
> >                      klp_shadow_ctor_t ctor, void *ctor_data);
>
> Does this signature change break the build for existing in-tree callers?
>
> It looks like samples/livepatch/livepatch-shadow-fix1.c and
> tools/testing/selftests/livepatch/test_modules/test_klp_shadow_vars.c
> might not have been updated to pass the new replace_set argument.

selftests will be changed accordingly once the RFC is removed.

>
> [ ... ]
>
> > diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
> > index c2e724d97ddf2..35e507fae4458 100644
> > --- a/kernel/livepatch/shadow.c
> > +++ b/kernel/livepatch/shadow.c
> > @@ -59,6 +60,11 @@ struct klp_shadow {
> >       char data[];
> >  };
> >
> > +static unsigned long klp_shadow_combined_id(unsigned int set, unsigned=
 int id)
> > +{
> > +     return ((unsigned long)set << 32) | id;
> > +}
>
> On 32-bit architectures that support livepatching (such as 32-bit PowerPC=
),
> unsigned long is 32 bits wide. Does shifting a 32-bit integer by 32 bits
> invoke undefined behavior here?

Ah, that is a problem on 32-bit PPC. I'll fix this in v2.

>
> Furthermore, since struct klp_shadow->id remains defined as an unsigned l=
ong,
> it cannot physically store a 64-bit combined ID on these systems. The
> replace_set value might be entirely truncated, resulting in hash collisio=
ns
> and subsequent issues when multiple sets manage the same resource.
>
> [ ... ]
>
> > @@ -126,7 +134,7 @@ static void *__klp_shadow_get_or_alloc(void *obj, u=
nsigned long id,
> >
> >       /* Look for <obj, id> again under the lock */
> >       spin_lock_irqsave(&klp_shadow_lock, flags);
> > -     shadow_data =3D klp_shadow_get(obj, id);
> > +     shadow_data =3D klp_shadow_get(obj, set, id);
> >       if (unlikely(shadow_data)) {
> >               /*
> >                * Shadow variable was found, throw away speculative
> > @@ -147,8 +155,8 @@ static void *__klp_shadow_get_or_alloc(void *obj, u=
nsigned long id,
> [ ... ]
> >       }
> >
> >       new_shadow->obj =3D obj;
> >       new_shadow->id =3D id;
>
> Because the id argument is now a 32-bit integer, the upper 32 bits of
> new_shadow->id will be zero. Should this be initialized using
> klp_shadow_combined_id(set, id) instead?

Right. will fix it.

>
> Lookup functions like klp_shadow_get() and klp_shadow_free() search using
> the 64-bit composite ID klp_shadow_combined_id(replace_set, id). When
> replace_set is non-zero, this lookup will always fail.
>
> This means klp_shadow_get() will erroneously return NULL, and
> klp_shadow_get_or_alloc() could duplicate variables indefinitely, leading
> to unbounded memory leaks.
>
> [ ... ]
>
> > diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
> > index 43115e8e8453c..6e3d6fb92e64a 100644
> > --- a/kernel/livepatch/state.c
> > +++ b/kernel/livepatch/state.c
> > @@ -203,7 +203,8 @@ void klp_states_post_unpatch(struct klp_patch *patc=
h)
> >                       state->callbacks.post_unpatch(patch, state);
> >
> >               if (state->is_shadow)
> > -                     klp_shadow_free_all(state->id, state->callbacks.s=
hadow_dtor);
> > +                     klp_shadow_free_all(patch->replace_set, state->id=
,
> > +                                         state->callbacks.shadow_dtor)=
;
>
> The shadow variable APIs previously accepted an unsigned long for the id,
> allowing 64-bit identifiers. The new klp_shadow_free_all() now accepts an
> unsigned int, but struct klp_state still defines id as an unsigned long.

Right, we should clearly document this API change.

>
> Will the implicit cast from unsigned long to unsigned int silently trunca=
te
> the upper 32 bits of state->id on 64-bit platforms?
>
> If the original ID exceeded 32 bits, the core might fail to locate and fr=
ee
> the correct shadow variables, causing a permanent memory leak during
> garbage collection.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260513143321.26=
185-1-laoar.shao@gmail.com?part=3D6



--=20
Regards
Yafang

