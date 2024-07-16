Return-Path: <live-patching+bounces-397-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92DF1932F22
	for <lists+live-patching@lfdr.de>; Tue, 16 Jul 2024 19:34:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBE642830E0
	for <lists+live-patching@lfdr.de>; Tue, 16 Jul 2024 17:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B185419B3CE;
	Tue, 16 Jul 2024 17:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSGBCBMA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBCEF9E8
	for <live-patching@vger.kernel.org>; Tue, 16 Jul 2024 17:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721151238; cv=none; b=h4gBWwxs8a4cFrWFybu9TPqnCbUfjb/wxcgwgZWGUehNpMFdPBc/1s5Ilx4Nr1rcLn6/bLWhj55fprlWTI/Y8bNG3AfjbB9VJoQTkbmXqPSsym8Ql3uPJbWo65ivZaQMb90putORIUpCmAXR09meX9XQ/zV7YruqJEYKP15fqG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721151238; c=relaxed/simple;
	bh=qGyXCrhNUK6TyGrxIWLwwJbufQ63hNtKWYrSJ2nTHgU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CZFxwFtaNiSDCfh7xATVhneqYltWHIgP+Z7rZX4OJxa+u8fa+W3n+oi2R4Bp4ued+3/Rs2e4NqiRgotSmT2+vhbnsQaSeTBl/P2sKursc+Bo1Y8M+HUjK9f53VPYnjqyQUron0FuLG4IqR13LVHb6UOZgd62qawhxPqiz/DChEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSGBCBMA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2621AC4AF0D
	for <live-patching@vger.kernel.org>; Tue, 16 Jul 2024 17:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721151238;
	bh=qGyXCrhNUK6TyGrxIWLwwJbufQ63hNtKWYrSJ2nTHgU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TSGBCBMAuo1vAfnfJHKMj5rl1/srKH5ZCt7zvJkPfI6V2VrY2LNNADUn4osiOiXqC
	 V7z8tz/5hagS7nQAMVDlzHFxZheVrvPUHSYUWcR7vbmcBcEYBH9AeFjpQMb2uBcW/n
	 kgEIOn7bxcsif8171jTEdoo1aUOzTViovXIDk9QqCx5LRJfZdfhu71DjNHFghU0jNy
	 TC1+oe4M6Q4WJey2jrTjc0qUfFj0V4q47b6233ergpBZplKO40mFy1G1vyqG8c4KnB
	 HO8v6HT0AdWpF9NUjPS60SMLLHu+gDnXHKIwg8Zik3iGGTTe+BnxEuFg60k9/BHnJj
	 Mayf6A6mK8MOQ==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52ea929ea56so10994450e87.0
        for <live-patching@vger.kernel.org>; Tue, 16 Jul 2024 10:33:58 -0700 (PDT)
X-Gm-Message-State: AOJu0YymC/IbgjTA1coKfzPPVUk8O5ZUtZSGdWu1cX4bYCjIWLVf3fxL
	8TLIj/Z245f/mYP2swhrvIjsL+NaScZtiOj0buGQWV6JajKU3J0TT57svs/vVsnfUqU6R9KlQJf
	AKyyTekVzkdoB21JsnMlXqGVIKFs=
X-Google-Smtp-Source: AGHT+IHv6bpHht2sWzcTK4fgbn5QHXYYMXCzy6Udut0dMXIiDl3TGUzbNEUqtG8/MMIjy7/yyZaLgB/sbdE37gkX+BA=
X-Received: by 2002:a05:6512:1284:b0:52c:dba2:4f1 with SMTP id
 2adb3069b0e04-52edf02dd26mr2853854e87.48.1721151236454; Tue, 16 Jul 2024
 10:33:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240714195958.692313-1-raschupkin.ri@gmail.com>
In-Reply-To: <20240714195958.692313-1-raschupkin.ri@gmail.com>
From: Song Liu <song@kernel.org>
Date: Wed, 17 Jul 2024 01:33:43 +0800
X-Gmail-Original-Message-ID: <CAPhsuW4qtN_wwcx3V7mNe5xs4TtkxFhzQzJFkkiBxuLP6-DdSw@mail.gmail.com>
Message-ID: <CAPhsuW4qtN_wwcx3V7mNe5xs4TtkxFhzQzJFkkiBxuLP6-DdSw@mail.gmail.com>
Subject: Re:
To: raschupkin.ri@gmail.com
Cc: live-patching@vger.kernel.org, joe.lawrence@redhat.com, pmladek@suse.com, 
	mbenes@suse.cz, jikos@kernel.org, jpoimboe@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2024 at 4:00=E2=80=AFAM <raschupkin.ri@gmail.com> wrote:
>
>
> [PATCH] livepatch: support of modifying refcount_t without underflow afte=
r unpatch
>
> CVE fixes sometimes add refcount_inc/dec() pairs to the code with existin=
g refcount_t.
> Two problems arise when applying live-patch in this case:
> 1) After refcount_t is being inc() during system is live-patched, after u=
npatch the counter value will not be valid, as corresponing dec() would nev=
er be called.
> 2) Underflows are possible in runtime in case dec() is called before corr=
esponding inc() in the live-patched code.
>
> Proposed kprefcount_t functions are using following approach to solve the=
se two problems:
> 1) In addition to original refcount_t, temporary refcount_t is allocated,=
 and after unpatch it is just removed. This way system is safe with correct=
 refcounting while patch is applied, and no underflow would happend after u=
npatch.
> 2) For inc/dec() added by live-patch code, one bit in reference-holder st=
ructure is used (unsigned char *ref_holder, kprefholder_flag). In case dec(=
) is called first, it is just ignored as ref_holder bit would still not be =
initialized.
>
>
> API is defined include/linux/livepatch_refcount.h:
>
> typedef struct kprefcount_struct {
>         refcount_t *refcount;
>         refcount_t kprefcount;
>         spinlock_t lock;
> } kprefcount_t;
>
> kprefcount_t *kprefcount_alloc(refcount_t *refcount, gfp_t flags);
> void kprefcount_free(kprefcount_t *kp_ref);
> int kprefcount_read(kprefcount_t *kp_ref);
> void kprefcount_inc(kprefcount_t *kp_ref, unsigned char *ref_holder, int =
kprefholder_flag);
> void kprefcount_dec(kprefcount_t *kp_ref, unsigned char *ref_holder, int =
kprefholder_flag);
> bool kprefcount_dec_and_test(kprefcount_t *kp_ref, unsigned char *ref_hol=
der, int kprefholder_flag);

IIUC, kprefcount alone is not enough to solve the two issues. We still
need some mechanism to manage the "ref_holder". Shadow variable
is probably the best option here.

The primary idea here is to enhance the refcount with a map. This
may be too expensive in term memory consumption in some use
cases.

Overall, I don't think this change adds much more value on top of
shadow variable.

Thanks,
Song

