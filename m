Return-Path: <live-patching+bounces-2852-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eD4VFtoJDGo5UQUAu9opvQ
	(envelope-from <live-patching+bounces-2852-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:57:30 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 58B7D57878D
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D0644302A567
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 06:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7BF439E178;
	Tue, 19 May 2026 06:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eHY0D2Ra"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE511261B91
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 06:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173249; cv=pass; b=gF4u2Mcx5xB2ms0+vZAJcF9N422bpU5Isa9giAenwwfV/XEDDtHncVApvyRoyJp6WkmTo+D7sS6U2FzPbuIaMwfUXsKjmqZR+QfGquaLQ2EUDNetQgwy4bWYUbxA783sAUDr9/6MvHraLpe6ECcDDbZD9NQE8iQAf+u1OgWdslw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173249; c=relaxed/simple;
	bh=NyNDhvSyv7XRMowpgU81uTJFnsKmqI+7pkyzUxT0azo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H+F+zSUDn1BtFQMbhx3SuXyCQu0GiyFKIvMpZx+QCE3y7/0zc61wa2pLzu0c7KUlQTFZzFD/ncRr/lS8UmKYn+YcQXirNpSzkgSXXf2k3e+dcIkOChZp2e4Xfr8sHzOu3hvStxC70c8n9NJy1cr30qSdLWlfh+7vBPZFbllJI/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eHY0D2Ra; arc=pass smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7cd35604a95so19613777b3.1
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:47:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779173246; cv=none;
        d=google.com; s=arc-20240605;
        b=Mtsn3KBYlWEvpaBYpHcs2ibYF9E7heEfLIj95CHbGxF01qvNS0INmk/xUtrv/SuRWO
         gdWJb3wFfF7E4YDLSbdeIUSUNFB049IDBmAGIvOI0khGPAy7uqnrie3ZKJRscElfJ6tv
         UfBO/kEdDpFktMzvJWZu7dZxIYE3RN0IX8qta8J2AZWBiZaWAt+ux0exlk4qGuR4RGR6
         BJIydIRdI44eHSFdgE1y1S9R7OBk0fyjUvj5D2V45Nr3fwOSP9FKslU9+xLNV07S6xay
         aG6XjjapUWeoTRoSceeV99nHgmV1ouEbDJJo5jHEihUYM+QXdFvrIoFe0lgtiiFeYP/U
         uJSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eaSPx0wbxWVv539GDTg5+Kyju9uz5Da///Zk6u5kJUA=;
        fh=A8zccnK6pC+VXgDO1XtB/elgzBUR2JQRpRWcg1cAxO4=;
        b=MpyxOVnVI+A6emOV6uXSPfOSBoyB+Kb0rcyfBnlnd67eQupOIQSm7HLF/Ca+sbw7s2
         1EqR5rbVHSHRKduQYHOmTsDVByd410ryfysAGVdVi8VKP7YdV3Em4zOc3TYbnHeXm4c0
         xm3Z/f1GsLXbUMjK0LKyeQ5ZQ4irZmvSUk4VeSCuALWRo4jwxYgR8Mw7fwuM3+z6ZKMO
         tGbs5Znu0OwZOW9h2d6o3EJ45f9KzMjr4GRv+AJCyFLvlJuFUCp3/06qnwksHjvvXl4K
         yz9a5OdJoHxwBPs+29oF9HPrpKTwwh+tzA1b5BzZo1MmX7UoZBPVevjiEZ8CefozL+lt
         2Qgw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779173246; x=1779778046; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eaSPx0wbxWVv539GDTg5+Kyju9uz5Da///Zk6u5kJUA=;
        b=eHY0D2Ra3wQQKP7x4SgsPeM236isM1gewTAcOcACxcFBifpjnrPovWCgLDUKAjd18Z
         PlbBZT0QN/X2LyUUnTQTa1z0YwYX+KEgfSaq4L3hsLGtROUMh2TbohjivWNmRUMqSqua
         hV1OZ+uT8VDpUh5CDPxy6y3Zz1oTru+ePPMmW1D7Pcz5S6T3dHt2KKmlsAmOlMzTNMnB
         IvYDtaJkRzx9tI2s28qoEfkuAXELOufhDla/ccUhz1yEEpKANMorab5DfeFAr3jfrcAr
         jRjZm/pfi0obYLz7HhRn14Pl6wHzk8Gif288oyb8mn8UEpzCl9EIerhXE7PBgZo3jub+
         ezOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173246; x=1779778046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eaSPx0wbxWVv539GDTg5+Kyju9uz5Da///Zk6u5kJUA=;
        b=k2JPcFSO1vQi0CG9B4B7Dvh/C1qIc9UWxAacpljK8sYTcni0VoU82yglIKiN304QCI
         y9xWetqiADi2m4gjXptnOqQ+2/qCRSXCMSWKQGqkR7eVPH0Z3iPNUG2HHvOjHNVRdm7V
         CpnhsT4Wxwtog8uCMo1G68wESi69tjQPh297oLFqd7sHgJ2vZXP8qeuk8QQh316yEKXb
         q/GgX+yiuiUnOWuj+2g2ZjOhyBZ36mU+qBrw0QHGU6+FIOPTv1TOrR/iXktRcujNE0Mv
         2KFsobFfwX8kRE6tKn17b1CdInfhR8BUWZQRfk22zud4loESXh4IoJRu/gTKHVC8PJIe
         Y4og==
X-Forwarded-Encrypted: i=1; AFNElJ/pP8R+Np+C901DiEACxQuccYjrCwwO4uZwpdf8rpOBRAhVeTHc9e3dPTVF97Ey96AKjMc9JdNT7I/qvdFj@vger.kernel.org
X-Gm-Message-State: AOJu0YzpRfg1fUI8q9hcQc6PB/7vRqlWiNeMmmx5mLcad7nd8fqfa4eJ
	DxOfBO1qbRbfpMqbbHAmrmeCMlL+zFr0PXh3+Gr9azN6m0AtRRj1oXvPzyeehozDvXWT1PgkrqF
	sKuP56M8lYV+tyfm6aAFzOWCxZd29f8pURUYXnq8=
X-Gm-Gg: Acq92OHTeK9lN+TO1aEcBTtCQsdVs8cgi5hwsEGXKqqnyb1l1+yuIU1FbIFhoREew6J
	KZuNdrmWnkO3Oi59Is0e3n7lo77pE7SOnThpClXeKZW39NISr8IifYDj1jEqiF/JLW19p3gFBzO
	VYcmLPQkBMBfxgxXW6zgPSeAWet9E8gUFcCJvvPBfArDK1M+2RCf8l9+/8xq082fuWlShP/ubFp
	0TxLpyQid4X4c3ii2ly2xYoV4sdJ3gVb+uyp637Ce8TQB8FMnGq9fN0UlbIuFs1fJhjr3X8WcjE
	e9VYlqYCtpMD+Ry2KCv1tHs4hswftJmjddYXj50q
X-Received: by 2002:a05:690c:c15:b0:7c6:e377:1dc6 with SMTP id
 00721157ae682-7c7e3134169mr200189587b3.0.1779173245682; Mon, 18 May 2026
 23:47:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513143321.26185-6-laoar.shao@gmail.com> <20260514224000.8316FC2BCB3@smtp.kernel.org>
In-Reply-To: <20260514224000.8316FC2BCB3@smtp.kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 19 May 2026 14:46:49 +0800
X-Gm-Features: AVHnY4JvQLoFhFQyXqActjgjy4XZjyhfXkPZbhv95lsGfAQ4gvQIoFIxkJ2j3RE
Message-ID: <CALOAHbD28PLp=35mV6n2G=tKtf8rGb_uVbTb4wY=6Erm+wjLGQ@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] livepatch: Remove obsolete per-object callbacks
To: sashiko-reviews@lists.linux.dev
Cc: jikos@kernel.org, joe.lawrence@redhat.com, mbenes@suse.cz, song@kernel.org, 
	pmladek@suse.com, jpoimboe@kernel.org, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2852-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[gmail.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 58B7D57878D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, May 15, 2026 at 6:40=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
> - [Critical] Out-of-bounds ELF relocations causing memory corruption
> - [High] Silent failure of livepatch state callbacks due to missing initi=
alization
> - [Low] Build failures due to unmigrated selftests and samples
> --
>
> commit deb761bd65e9a96a95798282bde72ddb362e1c0d
> Author: Yafang Shao <laoar.shao@gmail.com>
>
> livepatch: Remove obsolete per-object callbacks
>
> This commit removes obsolete per-object callbacks from the livepatch fram=
ework
> in favor of per-state callbacks. It drops the callback fields from the kl=
p
> object structures and updates objtool and the livepatch core scripts.
>
> > All selftests have been migrated to the new per-state callbacks, making=
 the
> > per-object callbacks redundant.
>
> Is this description accurate?

Selftests are untouched in this RFC. I'll revise the commit log accordingly=
.

>
> The callbacks field was removed from struct klp_object, but if modules li=
ke
> samples/livepatch/livepatch-callbacks-demo.c or the selftests still use i=
t
> in their klp_object declarations, won't this cause build failures?
>
> > diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
> > index 9265e0e504e0c..570366b9268c4 100644
> > --- a/scripts/livepatch/init.c
> > +++ b/scripts/livepatch/init.c
> > @@ -63,8 +63,6 @@ static int __init livepatch_mod_init(void)
> >
> >               obj->name =3D obj_ext->name;
> >               obj->funcs =3D funcs;
> > -
> > -             memcpy(&obj->callbacks, &obj_ext->callbacks, sizeof(struc=
t klp_callbacks));
> >       }
> >
> >       patch->mod =3D THIS_MODULE;
>
> Will the state callbacks be executed when the patch is enabled?
>
> Looking at livepatch_mod_init() after these changes, patch->states is nev=
er
> initialized:
>
> scripts/livepatch/init.c:livepatch_mod_init() {
>         ...
>         patch->mod =3D THIS_MODULE;
>         patch->objs =3D objs;
>
>         /* TODO patch->states */
>
>         patch->replace_set =3D KLP_REPLACE_TAG;
>         return klp_enable_patch(patch);
> }
>
> When klp_states_pre_patch() iterates over patch->states, won't it silentl=
y
> skip the uninitialized callbacks?

Since these callbacks have been moved to klp_state, they must be
initialized first. Note that the KLP_*_PATCH_CALLBACK macros are
broken after patch #6; I will fix this in the next version.

>
> > diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> > index 4d1f9e9977eb9..6e2762de3d512 100644
> > --- a/tools/objtool/klp-diff.c
> > +++ b/tools/objtool/klp-diff.c
> [ ... ]
> > @@ -1566,8 +1566,8 @@ static int create_klp_sections(struct elfs *e)
> >               reloc =3D find_reloc_by_dest(e->out, sym->sec, sym->offse=
t);
> >
> >               if (!elf_create_reloc(e->out, obj_sec,
> > -                                   offsetof(struct klp_object_ext, cal=
lbacks) +
> > -                                   offsetof(struct klp_callbacks, pre_=
patch),
> > +                                   offsetof(struct klp_state_ext, call=
backs) +
> > +                                   offsetof(struct klp_state_callbacks=
, pre_patch),
> >                                     reloc->sym, reloc_addend(reloc), R_=
ABS64))
> >                       return -1;
> >       }
>
> Does this result in out-of-bounds memory writes during ELF relocation?
>
> Earlier in create_klp_sections(), obj_sec is allocated using the size of
> struct klp_object_ext, which is 24 bytes:
>
> tools/objtool/klp-diff.c:create_klp_sections() {
>         size_t obj_size  =3D sizeof(struct klp_object_ext);
>         ...
>         obj_sec  =3D elf_create_section_pair(e->out, KLP_OBJECTS_SEC, obj=
_size, 0, 0);
>
> However, the new relocations are created using offsets from a completely
> different structure, struct klp_state_ext.
>
> Because offsetof(struct klp_state_ext, callbacks) is 16, and the callback
> offsets go up to 24, this applies relocations at offsets 16, 24, 32, and =
40
> within obj_sec.
>
> Won't the relocation at offset 16 corrupt klp_object_ext.nr_funcs, and th=
e
> subsequent relocations write entirely out of bounds of the 24-byte obj_se=
c
> buffer?

Nice catch. I will fix it in the next version.

--=20
Regards
Yafang

