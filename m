Return-Path: <live-patching+bounces-1284-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00C20A6614E
	for <lists+live-patching@lfdr.de>; Mon, 17 Mar 2025 23:11:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58EB917E166
	for <lists+live-patching@lfdr.de>; Mon, 17 Mar 2025 22:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF4C202F60;
	Mon, 17 Mar 2025 22:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gtC4RqZI"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387D91FAA
	for <live-patching@vger.kernel.org>; Mon, 17 Mar 2025 22:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742249472; cv=none; b=uFo+NKzaqzPX0wAxBnduaddy9HNuBY9QNzDDOwrL+tkudN4rUB1kh6V4mGWbJs0Tv9i2umD5aby1BfyKTRdYtqmoL7VaC9YIGBTu7JiagrBAS32tLo0PjgDFgag0OEwWUrw5nTqmBURLR815Nhm5o3ANYTnM0LQQBCiORpWD8mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742249472; c=relaxed/simple;
	bh=tCjoLat2rFsrp8hCCZZNiD1pfm58DlN6QkIccmaC890=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PiOHvYzG3t/Q6UxQbLvxXUQ/0oEuU8I/Lm39RD6Wql2bCzsPtQ6I1nd93VRzaTrjCoygRubcTT5A2E3b3D+hNOIS+s3DGrzgCvEeQE4gw9vjnY1jyleKt3swnyBg6wE3KyDIa1A0nU5P4gnYrSiQoBTHMdt8Yb2XAKU5PSwQyK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gtC4RqZI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A957BC4CEE3
	for <live-patching@vger.kernel.org>; Mon, 17 Mar 2025 22:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742249471;
	bh=tCjoLat2rFsrp8hCCZZNiD1pfm58DlN6QkIccmaC890=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gtC4RqZIqTMJLlmvrg+GlYBeTcLtEvQgtBjD72JVTz243oFt3ORv101RWG+EyMhbf
	 h3P9COF2zsXu5LTOs1yk/XFHuBBrljygEaPi9ISxjYEg1doHwSC1uvP0kc3Jgr/2xY
	 k7YaDIRDmQpcnZAEM0ZUxpWlEMQVnfOiGPAY2mB/QtBo3dGORbx14p+M0fpuiJsq4G
	 nC0EFlIAAln3KWngDVhqmAMJhs3ZyL6J8NGo1KFyhjzhlumOHtkLxTJE6k3EkYOB3v
	 76OyrYzCx/yr7Mynjpzzz+DiLOluKVAp5OWw0AtaWlBxLo4qyt9kyqgUdQ/1imd7q+
	 IdCQM+yoVGdfA==
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3cf880d90bdso18333865ab.3
        for <live-patching@vger.kernel.org>; Mon, 17 Mar 2025 15:11:11 -0700 (PDT)
X-Gm-Message-State: AOJu0YwETcbgyMNHE0fMo+fhOv2+msgqOnMy+hDdGshBsEfj6ggYdWxj
	qqQh8RUXNNwMGW0o1n5EhgdxCkYYaKUZ+eRWi7nk4CLLSl/n6+lB1m3kSfnSHP+cAPeLZn5ASQs
	89skIn4oJA81llb0Qs31KZbAv0X8=
X-Google-Smtp-Source: AGHT+IF+I8XX2p5IittWeZGzH7X4cZvVl0kNX3MJH+jgS4eOYMbrEiLWO1t1557XEPHpwZ5hvnOphqNV5/PdJuQGllc=
X-Received: by 2002:a05:6e02:1fea:b0:3d1:883c:6e86 with SMTP id
 e9e14a558f8ab-3d483a09c3emr169095125ab.8.1742249471077; Mon, 17 Mar 2025
 15:11:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317165128.2356385-1-song@kernel.org> <2862567f-e380-a580-c3be-08bd768384f9@redhat.com>
In-Reply-To: <2862567f-e380-a580-c3be-08bd768384f9@redhat.com>
From: Song Liu <song@kernel.org>
Date: Mon, 17 Mar 2025 15:10:59 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6UdBHHZA+h=hCctkL05YU7xpQ3uZ3=36ub5vrFYRNd5A@mail.gmail.com>
X-Gm-Features: AQ5f1Jr9ebdu2Zy4IaCYF7xOLLXNpCj4APULd_nrYGnBOn82U-Ezu_x-WGn4PiI
Message-ID: <CAPhsuW6UdBHHZA+h=hCctkL05YU7xpQ3uZ3=36ub5vrFYRNd5A@mail.gmail.com>
Subject: Re: [PATCH] selftest/livepatch: Only run test-kprobe with CONFIG_KPROBES_ON_FTRACE
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, jpoimboe@kernel.org, kernel-team@meta.com, 
	jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 17, 2025 at 11:59=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.=
com> wrote:
>
> On 3/17/25 12:51, Song Liu wrote:
> > CONFIG_KPROBES_ON_FTRACE is required for test-kprobe. Skip test-kprobe
> > when CONFIG_KPROBES_ON_FTRACE is not set.
> >
> > Signed-off-by: Song Liu <song@kernel.org>
> > ---
> >  tools/testing/selftests/livepatch/test-kprobe.sh | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/t=
esting/selftests/livepatch/test-kprobe.sh
> > index 115065156016..fd823dd5dd7f 100755
> > --- a/tools/testing/selftests/livepatch/test-kprobe.sh
> > +++ b/tools/testing/selftests/livepatch/test-kprobe.sh
> > @@ -5,6 +5,8 @@
> >
> >  . $(dirname $0)/functions.sh
> >
> > +zgrep KPROBES_ON_FTRACE /proc/config.gz || skip "test-kprobe requires =
CONFIG_KPROBES_ON_FTRACE"
> > +
>
> Hi Song,
>
> This in turn depends on CONFIG_IKCONFIG_PROC for /proc/config.gz (not
> set for RHEL distro kernels).

I was actually worrying about this when testing it.

> Is there a dynamic way to figure out CONFIG_KPROBES_ON_FTRACE support?

How about we grep kprobe_ftrace_ops from /proc/kallsyms?

Thanks,
Song

> Without looking into it very long, maybe test_klp_kprobe.c's call to
> register_kprobe() could fail with -ENOTSUPP and the test script could
> gracefully skip the test?
>
> Regards,
>
> --
> Joe
>

