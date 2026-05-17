Return-Path: <live-patching+bounces-2838-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YDNzJo/DCWrZogQAu9opvQ
	(envelope-from <live-patching+bounces-2838-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 17 May 2026 15:33:03 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A1363561357
	for <lists+live-patching@lfdr.de>; Sun, 17 May 2026 15:33:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 241983001CE5
	for <lists+live-patching@lfdr.de>; Sun, 17 May 2026 13:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6923372EE3;
	Sun, 17 May 2026 13:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUtFaWLc"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5081136F42B
	for <live-patching@vger.kernel.org>; Sun, 17 May 2026 13:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779024776; cv=pass; b=NHc/UHEZh7slLTgXPTzcox5LVQZ3uV5WneTeLIbJrSNee5fabeAYNRKBMiln7HjZ1oZu7UQCr/6XOZyhH2z83WlrhTutt9YViNvseb5sPWB7dqSbSKRZhJ3hqIO5sMDw1+xYYUvIbe3Nfpds5ETnp4M+U/xVEhjivpc8it2Dc1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779024776; c=relaxed/simple;
	bh=Me13lM9jQNdFUFO9f6NP1VUcg617l+KY6RpnBp03sKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MFk8CkumVGebs73Ml2q6uQSZWNWgX5/EVhQkplvd/VfXFisCxtbYfC7X5Lk82BSQ2otDtGEhB+0WWmXvRrQBKlC88/4HomKCZCRh42/NRJFGNJh6fADn2B1yp+c+g95mAgkhTHDacs1b/jWgW9Xl5P/rPl+GzWYYKgSA5pSneTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUtFaWLc; arc=pass smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7bf0b1a47b1so7540237b3.0
        for <live-patching@vger.kernel.org>; Sun, 17 May 2026 06:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779024774; cv=none;
        d=google.com; s=arc-20240605;
        b=PmhGriZZ6Cs5i0/FrKTfphVhTRirVZEgaJ7yqECkPiJTImJq9UOrv0m/KotTxdxeAO
         cIMmrg6+7rEsgHimiTV6pDLhY+uWUr5Jw/BuX9Bycg6eZu8LwKL5VyZaEtThMvf0ZZf1
         BrXgLeOu87rxesywYKsCV69NbVeTzwFV1W2GoNq68rmfxnzR6gkfgxBYrF+Qc3R0iZHi
         M/R9VUeI+6NuIMmnVTkEiz5a/GFO1PwO3QDUTdhUkxF8Rz+GjnF7pW+e/ZtFqtpgBKtr
         kxSxE7jbq5HTQIiNJs65AbtaEvn3rCgg7QE2RSWuzTyB3sNfbnAKsrPn+H0p/3j6onbN
         Tf3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uMwhRipX67UD0+c6NpFaV2oXtR27/5WyYFPFRLfw3uE=;
        fh=txeZD0R7KbxeavOxT99zDLgIrrx/o5OPcfa6gAdKS64=;
        b=XIYb/ebVx/6haANSIzzH/MMwfumt3nCO8EGJ2lae46LvRZY4qcbD00OAFQCyamI6zW
         g/60dF05HXOyzrnlWH4pbXwNy1EBprQNwH/C3LVMu1n7I9jyX8PSGL8uihv1He2+z3Hl
         y6GgDBxWAyixpjJJezzMmVFv26cw+IHX35MUivulHNX2UG6l7K361X7ImP11n1Jr0YlJ
         3HNr8mYRhKnkoXobhS8hFg6jOmIJsaEnbrYcBa1gylInTWIdE9h80q+0qz3Nj2oGQmES
         7w+K1+6qFyFxIH6NN1h1fW0Ppqf9ADbiDyBuvmBXgPRNKsRmOVEeAxRfcUg16zvTwugv
         rZPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779024774; x=1779629574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMwhRipX67UD0+c6NpFaV2oXtR27/5WyYFPFRLfw3uE=;
        b=aUtFaWLcyVrycrEE/v09RyugslxL78Kh/N/TwtLt+/yknkrXI2+jkDSRBTYcxty2/g
         /BTNa++gG2zwVbmhg6ZyvnDb2kWOTq8toZqFqN0hyxcjflw+v6J3UlQLz+Z8m1P4/5Ty
         JKQMZXmdQMya/Us1I1zyp1EBP4yHdvH2Co2BuovaNWSoPrNVDHpsifg41uqDT6tWcN40
         jO4NuB6lH+/srkO0xTHQOVugMpxbMR6tE0zbawrBlKGo6BguqIbAA1ceL6d/us3tFJar
         7qafmKWREcyjepM6f7XyvOlqJtDQN8GSgXvIhV7bKeDe233Vc3sxv6njqkT7BI/E1TQp
         je/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779024774; x=1779629574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uMwhRipX67UD0+c6NpFaV2oXtR27/5WyYFPFRLfw3uE=;
        b=XskeZzR31JLfrs6Umn0V+puSxMT4QimPT7QM/J2dtfaHPagpt3UcYmNUXegOFlRzFw
         Vzq8BthDVU0f1w/EvelrfKTgs4R9i/T3qXvX025UoM4hFpjXyN2fp9rLBTZK5eo7h9HQ
         8ADJuewDpFG/kAyw7F1HChTY0ypdZf0SVoyxCbO5cKKESgEesv4jRDK5NLA4WiUYBu5F
         MJ7gWk3DnJCXpBInEPAMlTcCMPmkzRRe9Dm8XkwdkI5oK6UYLcqcNafxQp++yReCTY02
         I6/dWfnFIiKp24Pf9UhgKagVIbwFBl7Tw5Wafc3j2E/d+qa8U+kvgeAwRppDXKJBRYvV
         SNjA==
X-Forwarded-Encrypted: i=1; AFNElJ+pWJ4uosrUFwJ3OMWRoas65jOKl5K46Md3kCrxGJmM+r8m0JHE9C5zOfaZAar+LW/eM8U87HUCgrWkRDXC@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+kddI4GLoJr/9+IIej6un/n3iX5M8q2TvL6/V/1d96Jgy+7bu
	2zF5RecpSEz06uT3qiES0r6NC5A95d8b5jmWHanRfCBGoDvG4p1+zt8OaWzFJMZiiaRzaacpid+
	Qr+WQCmD0tUUNxYk3dsbV+ALiMtmYsr0=
X-Gm-Gg: Acq92OG7UrO6PBINYmikvy/MjGrLEHXnSJNMocYn/Sv86r3FCfoFQYqiYqXaBiZnZvP
	6MUEi8owD44GV/C76W7rJKP1DIhjVg/VzvrVx1FImy3IfaVh79YPMjJy85yuYpycgi67l+Ble2t
	fzW7MdyBFvvyTsbI62Etz433q6PYbDDgMVrw1GiQVJQ8qNjqk+Hu28LORoEW4uk32oiN2qrd/ce
	IWL+McwdV++rnSHxgvGdOk1EGOGn6cG40Wh+lvsI6eC62/0zZBDIoxj/jmnFLS8KV4rvt343o7J
	MrYJNf5Z2do3gH8I5zh9K6gJkuAyMbvkThnL1IiP
X-Received: by 2002:a05:690c:f15:b0:7b3:ca3b:84a4 with SMTP id
 00721157ae682-7c95aa5f23amr125105337b3.18.1779024774198; Sun, 17 May 2026
 06:32:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513143321.26185-2-laoar.shao@gmail.com> <20260514205439.925F1C2BCB7@smtp.kernel.org>
In-Reply-To: <20260514205439.925F1C2BCB7@smtp.kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 17 May 2026 21:32:18 +0800
X-Gm-Features: AVHnY4I0OHG_DMlGc3-4Hr09LP87tpwxlQNyIPLcFKrv6iPr-_-qKusBySvBicU
Message-ID: <CALOAHbCpRO9-EpFURKPw7NOj0sXhkEMwNp_orVjXhWfhP9dtEw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] livepatch: Support scoped atomic replace using
 replace set
To: sashiko-reviews@lists.linux.dev
Cc: mbenes@suse.cz, song@kernel.org, jikos@kernel.org, jpoimboe@kernel.org, 
	pmladek@suse.com, joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A1363561357
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2838-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Fri, May 15, 2026 at 4:54=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 4 potential issu=
e(s) to consider:
> - [High] Module reference leak during forced transition.
> - [High] Silent semantic reversion for zero-initialized out-of-tree livep=
atches.
> - [High] Sysfs ABI breakage and incorrect type formatting for the `replac=
e` attribute.
> - [Medium] Build failure in livepatch selftests.
> --
>
> commit 8a05e8a3ebd9241541926ac6aba19452a820c899
> Author: Yafang Shao <laoar.shao@gmail.com>
>
> livepatch: Support scoped atomic replace using replace set
>
> This commit converts the boolean replace attribute to a u32 replace_set
> to allow livepatches to atomically replace only existing patches within
> the same set. Patches with different replace sets can now remain active
> simultaneously.
>
> > diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> > --- a/include/linux/livepatch.h
> > +++ b/include/linux/livepatch.h
> [ ... ]
> > @@ -137,7 +138,7 @@ struct klp_patch {
> >       struct module *mod;
> >       struct klp_object *objs;
> >       struct klp_state *states;
> > -     bool replace;
> > +     unsigned int replace_set;
>
> By removing the boolean replace flag, out-of-tree livepatches that
> zero-initialize their patch structures will now default to a replace_set =
of 0.
> Will this cause them to unintentionally replace all other zero-initialize=
d
> patches instead of stacking safely?

As previously discussed, backward compatibility is not a concern.

>
> Additionally, does this rename break the livepatch selftests in
> tools/testing/selftests/livepatch/test_modules/ (such as test_klp_state2.=
c),
> which still explicitly set patch.replace =3D true?

Selftests are currently excluded from this RFC

>
> [ ... ]
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -454,7 +454,7 @@ static ssize_t replace_show(struct kobject *kobj,
> >       struct klp_patch *patch;
> >
> >       patch =3D container_of(kobj, struct klp_patch, kobj);
> > -     return sysfs_emit(buf, "%d\n", patch->replace);
> > +     return sysfs_emit(buf, "%d\n", patch->replace_set);
>
> Does changing the sysfs output from a boolean to a replace set ID break
> compatibility for userspace tools expecting strict 0 or 1 values from the
> replace attribute?
>
> Also, since replace_set is declared as an unsigned int, will using the
> signed %d format specifier cause large replace set IDs to overflow and
> display as negative numbers?

Should use "%u" instead.

>
> [ ... ]
> > diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transitio=
n.c
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> [ ... ]
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
> >                               patch->forced =3D true;
> >               }
> >       }
>
> Could this inadvertently set forced =3D true on the klp_transition_patch
> itself?
>
> Since klp_transition_patch was already added to the global list during
> klp_init_patch(), it will match its own replace_set here. If it is marked
> as forced during a patching transition, wouldn't we leak its module refer=
ence
> in klp_free_patch_finish() when it is cleanly disabled later?

Right. it should be :

                klp_for_each_patch(patch) {
-                       if (patch !=3D klp_transition_patch)
+                       if (patch !=3D klp_transition_patch &&
+                           patch->replace_set =3D=3D
klp_transition_patch->replace_set)
                                patch->forced =3D true;
                }

--=20
Regards
Yafang

