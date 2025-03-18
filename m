Return-Path: <live-patching+bounces-1290-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99DA3A67B59
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 18:49:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C05B419C4143
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 17:49:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E9C212B2F;
	Tue, 18 Mar 2025 17:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r1ovao7R"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1A8212B07
	for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 17:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320162; cv=none; b=bGYo191/RnZjWVQXPOt/mdWz0vOQWpFfq52kdyKb8ZcDoibjfmOfCdTAITKBa2M9qCR1r3xcikH8LxAYnEzOeOfXR28nxHkEs+MFpdjWIyTglMUxrew1A9u7GbgRUkp5ISw9OTE1kAJSRYzJ7+/vaV31ruXARL3LgCVCvhyJkZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320162; c=relaxed/simple;
	bh=MlIDcxeW9WGs80qzKz/07E74M2nbfAegEq9IFaNba2A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SaLYORxscUmLO5YNhJa/cwv2OBpoySmL3Rh3r501BXoKzUNI0g4y9GoTJFH6ULz6oZMfagx73Zhz8s2wnUOGfu+xiial8yIirostxFjIZ5BrUIGCiwUP8vb6LykBgo911wtBci/wf5tdCZVMvKGJJn5Yj99qCjz0XRHyTrBMKfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r1ovao7R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4278C4CEE3
	for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 17:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742320161;
	bh=MlIDcxeW9WGs80qzKz/07E74M2nbfAegEq9IFaNba2A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=r1ovao7RethHO/yQARm5zAz60l0MM7eS092Q8W1we51UAP9pzcN9w3EOFgg7MCju1
	 oCTIHmdXY94nFnMLa0pttPKZPrq5jUnhme5+j045A3Gt+mojoMu+4E/oaLhtqcjCM5
	 MxWFItX3JQcxq0GE9PfpCbuZYQvCyJL1xzqjuFID069D5+Zu+mPF6yISypDhLfYP7U
	 VhdLe3TU7cx8D0pppBaltodqnnnWTE/iPRHTJDgtxl2OP4j2D/YfXUdcrKqODKi/OK
	 3lGNRLeNSqyPUpo4nTvf40GY0eoVfAuOFg1aI6TcnNce2Xfn2tXnSTKLpkctokrvdA
	 vBPRxASUl1P7g==
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-85b4277d0fbso211096639f.0
        for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 10:49:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXn19Bh5AiIxhSXeOuc/yZw5pQhhZk5XWRCddtz4EC0L6GW+kIIDE4LIuKeRT3oTsXHsx5IHvYqT0Qd2ep5@vger.kernel.org
X-Gm-Message-State: AOJu0YxOA0c8nyFEIUO+yER67sfSrUHyHtWvp9Jti3Yci45lXIC+bbOa
	fLrPOvynmR2rbcEDFo79CnCFsIq//kgY7I6wH1WNTqciNvbcnQNjjFmZKapcSeC//cHKfKxOW3k
	XxZjU/vjfYaYblpkPwY1Nylex4z0=
X-Google-Smtp-Source: AGHT+IE1I2cSGplJMi/L3vGsIKUmBuXHoun+4Y7HC6ILjTgu7QbNYUFBDOotSALIPRW7kp3RRkvDiypIIszITOWqrr4=
X-Received: by 2002:a05:6e02:3a0d:b0:3d0:21aa:a752 with SMTP id
 e9e14a558f8ab-3d4839f442amr214208905ab.2.1742320161136; Tue, 18 Mar 2025
 10:49:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317165128.2356385-1-song@kernel.org> <2862567f-e380-a580-c3be-08bd768384f9@redhat.com>
 <CAPhsuW6UdBHHZA+h=hCctkL05YU7xpQ3uZ3=36ub5vrFYRNd5A@mail.gmail.com>
 <alpine.LSU.2.21.2503181112380.16243@pobox.suse.cz> <Z9l4zJKzXHc51OMO@redhat.com>
 <CAPhsuW63DceUb6Gfv8QaxwZFO+eKCNotdcppLhe=FJ0Ujoh=CA@mail.gmail.com> <671de80a-f3a4-9cd7-0de0-9a8930113232@redhat.com>
In-Reply-To: <671de80a-f3a4-9cd7-0de0-9a8930113232@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 18 Mar 2025 10:49:10 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Qkj9+rGW0gJzimm4hMJrBvb5mT7v2VTfWmqQsY1UEnA@mail.gmail.com>
X-Gm-Features: AQ5f1JoHeWSTofTsv6yyFyrdhl-A-PEsfwfoGbbQw1rzVFxH7QCCENdiZmQPPjU
Message-ID: <CAPhsuW7Qkj9+rGW0gJzimm4hMJrBvb5mT7v2VTfWmqQsY1UEnA@mail.gmail.com>
Subject: Re: [PATCH] selftest/livepatch: Only run test-kprobe with CONFIG_KPROBES_ON_FTRACE
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, jpoimboe@kernel.org, 
	kernel-team@meta.com, jikos@kernel.org, pmladek@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 10:18=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.=
com> wrote:
[...]
> >> Also, while poking at this today with virtme-ng, my initial attempt ha=
d
> >> build a fairly minimal kernel without CONFIG_DYNAMIC_DEBUG.  We can al=
so
> >> check for that via the sysfs interface to avoid confusing path-not-fou=
nd
> >> msgs, like the following ...
> >
> > We already have CONFIG_DYNAMIC_DEBUG=3Dy in
> > tools/testing/selftests/livepatch, so I think we don't need to check th=
at again.
> >
>
> Ah right.  Do you know what script/file reads or sources that file?
> (It's such a generic term that I get a bazillion grep hits.)  When I run
> `make -C tools/testing/selftests/livepatch run_tests` it just builds and
> runs the tests regardless of the actual config.

I am not aware of any script reading the config file. It appears to be a
convention that many subsystems follow. The subsystems may have
some CI that reads these config files. Some subsystems use more
complex logic around these config files. For example, bpf selftests
have 6 config files and 4 DENYLIST.

Thanks,
Song

