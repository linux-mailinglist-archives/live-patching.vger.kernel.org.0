Return-Path: <live-patching+bounces-601-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C1CD796C994
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 23:32:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DE09B21269
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 21:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741E214901B;
	Wed,  4 Sep 2024 21:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2KC8rb4"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ED45256;
	Wed,  4 Sep 2024 21:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725485550; cv=none; b=b/VV6Hk1tZO/gAFcTB3ELCCI6ClL43geho1XvQT9MZ4RL0Sl16GStAuvRjrOklcRV5PTKW+/V6Oqf3moeudTgvZNfQYH3yZTqGtsB2nqs8bup0TH4CF8HNwMvUT4pFCNJ8hjQ6D4KRVKZ7EnmE2m5Cu+oT5oRHoH+5zh2nWlCV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725485550; c=relaxed/simple;
	bh=SfW0zczg/wAmV5mEdCEyMhNAUhzt5Ogh9ULFBK4hnP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aViDb5X9S+7Gq33ZjfUo0VZ0RyCU1c8QKUf3kbYXH1xQvCHJ6CQN7ebnnpt7RhaQJNX8UBQss5s+gIdephukIY0dAXUBaIdIeGd7VSbiLozmyunreRi8LJ85J2QJJlVpf3slsPsKiMfTFlAQ7QXyKnCgHknmMgj/5RgQgtbNnUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2KC8rb4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5FEC4CEC5;
	Wed,  4 Sep 2024 21:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725485549;
	bh=SfW0zczg/wAmV5mEdCEyMhNAUhzt5Ogh9ULFBK4hnP0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=F2KC8rb4Pt5cS8jBJhGdl59Yfm7mZurvfFcyWIo6B5ttFbJLlFnCRAoNrEqMLwdYQ
	 3NDqfT8FEc+nDFtdjlX4lh6Et18mQZ/2J6OKTipSAKtoh7BFjPTk7fg53+eTm5lQQs
	 1nseQZztR6xnP8q3WqR25V82eQsFjgoSumBCrkZilideeKBpEF088aSvieZrTThxQM
	 w5f8ecbEA6ZhdOjhFuChvBYrOC+1KVt/aBnB1p5hgObhMUtu62VSzzA6IWqhI6Kerj
	 cZPDsRSf0sH7kp7eZhoboyelbCNHbxbr2yIcqKwhF4wPT7Lqas/U9HDsDm2By4mSqf
	 DMCtybVi8dQDA==
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-82a20593ec1so618439f.2;
        Wed, 04 Sep 2024 14:32:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVP6S6pkyOIZGS1jcy1gGXGDYeQjFmBSO46UVSf2r4sQKihHpHv9ndMcnql66QWqwSuXajqwXSi7oPvkns=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7wQYDF5dt8LBJ/R7eQTFvi5XK95Nrv6MlGg/hiRkRZRR7nmYU
	HqdPeVGzyRNSaMhdvC9t4o8crRL2RlsKxYGJwOB5URjODbQ4ipBl9MSR2vzQpcoNtXukmdD+ElM
	/QcfroO5JiQOrYAfnawwUpD8Gtxw=
X-Google-Smtp-Source: AGHT+IFO63gxGBt6VRzQM9yIHjWofIauarhJ3Mzzmhpy8ciRy9py9ge1ZM5aTtv7JSq5cWtZCst3M1WbxU7TEmnY95w=
X-Received: by 2002:a05:6e02:1706:b0:3a0:4569:db73 with SMTP id
 e9e14a558f8ab-3a04569dd98mr21230775ab.28.1725485549115; Wed, 04 Sep 2024
 14:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725334260.git.jpoimboe@kernel.org> <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
 <20240904043034.jwy4v2y4wkinjqe4@treble> <CAPhsuW6+6S5qBGEvFfVh7M-_-FntL=Rk=OqZzvQjpZ6MyDhNuA@mail.gmail.com>
 <20240904063736.c7ru2k5o7x35o2vy@treble> <20240904070952.kkafz2w5m7wnhblh@treble>
 <CAPhsuW6gy-OzjYH2u7gPceuphybP8Q43J9YjeUpkWTh5DBFRSQ@mail.gmail.com> <20240904205949.2dfmw6f7tcnza3rw@treble>
In-Reply-To: <20240904205949.2dfmw6f7tcnza3rw@treble>
From: Song Liu <song@kernel.org>
Date: Wed, 4 Sep 2024 14:32:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6MHSAg3WcikRCm79WQYB3331xd3+Afhwt_HfuUtCtkSw@mail.gmail.com>
Message-ID: <CAPhsuW6MHSAg3WcikRCm79WQYB3331xd3+Afhwt_HfuUtCtkSw@mail.gmail.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Jiri Kosina <jikos@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Marcos Paulo de Souza <mpdesouza@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 1:59=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> On Wed, Sep 04, 2024 at 01:23:55PM -0700, Song Liu wrote:
> > Hi Josh,
> >
> > Thanks for the fix! The gcc kernel now compiles.
> >
> > I am now testing with the attached config file (where I disabled
> > CONFIG_DEBUG_INFO_BTF), with the attached patch.
>
> Probably a good idea to disable BTF as I think it's causing some
> confusion.

Agreed. We disabled BTF in kpatch-build, which works well so far.

Thanks,
Song

