Return-Path: <live-patching+bounces-1164-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E4FA3358B
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 03:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5F3B188AF87
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 02:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F2D2040A8;
	Thu, 13 Feb 2025 02:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cR6QRsE2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D889820371F;
	Thu, 13 Feb 2025 02:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739414446; cv=none; b=QF/hZMThorIThDEiyj4eEpt2rQbQKrfyRt+aFZ+0OdO46C2/n8u2TdrZjSuUNT2ynnRpKcHnIAb9KdrKVw/x40GcQ4gW/wbHucP9V4VPE9s5ukNJe/JfhhMs4tAMghcRvR9rfLxIG2U3t5tPX/OzVNxI8gzjG/UnV9g32336KOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739414446; c=relaxed/simple;
	bh=9+J9A1tRdlpiZAuCMrDFjEHXNb2a6suCfw+XdHBTunA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VZZIFdPDUfF69tR4HAaznU6jNd6tcwjh6gUanoSiwizZj6K8Mjg9Qf5hpgNdcNmPYm5zfCkJqcFAciJT+IL2Y56ngwSCwaJVrGNMk1mGWKHZcCWR3/vKSGpanAeRHI1z1VvtsG0quz5Vatu8ytLwck7B2NsGrNqOnSdxcJWsXqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cR6QRsE2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF24C4CEED;
	Thu, 13 Feb 2025 02:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739414445;
	bh=9+J9A1tRdlpiZAuCMrDFjEHXNb2a6suCfw+XdHBTunA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cR6QRsE2QISausMky6hpqpB2ypd+N5qQwr5MBfdXrXhWG8cwpbsVqLmPYkb6oupwS
	 2pzRVD1M5AzmpUL3V8V4ry35BDOm1zY9IZ6EXRz64Oq0oEZnwY1qfULy9OYtHEFTpX
	 pD8ZTIDga4VFUwC+4MCpivFioZXqLicAfC4jD5XmI+YQHh6O6WBu8omDttEv9rCDlz
	 +SUb9zMc0lKTio9Eh/b4TSOyjQrKorvUSBBRckpI5a4hMwSxYu8tK9TxiLVeUPRVav
	 1jT3+qBN6c7aAN/zf+NyEgPn7t3bugETudrGS1AZ8duqqrz95VcrAHzOO0xHnBLuF9
	 hYMhtNFLa40qw==
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-85525784a97so31182339f.0;
        Wed, 12 Feb 2025 18:40:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVs79PGlEUaZ1WPq0nYyrmhLgiBbTlfWCwxUv42ylKQtPEkUy+3deKjTQ49xPE/n0B8J1pKyEsFlQHL//w1lt1c8g==@vger.kernel.org, AJvYcCXf76g9a/be1Uov5slBh+jkp89jZJYdSDVMVRZY0B+hDZejMgmQ/90bPWIlth2VA8siFL7T/0QjgR05dBw=@vger.kernel.org, AJvYcCXjKyNUacG4ZWSLwXTRPXeOzHsgqEXec+b3KbO2ya+mlEBhccX0Iy47cQdzgAAN0uNzJExUetlnisHSnB+HzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIMg6jx0amtBQS9Gu9BRA0HK8DTapz0EiVwVT05cL3BqWPpVE2
	jjIkIrDC/2TmNRvtLgkqVoeDewvN5t0bHgThj3+myMaj8KTtNWB8s7nObH1LP2WMQGXzI+dwx0D
	fU0gdlhukPBm+BS272+KZFf5z1mE=
X-Google-Smtp-Source: AGHT+IG9WVHruY+6TH77fSuZ307OK22ED1oLkMtB4PjP5hgJMrT0rljG2gvuZBGUwjypyUVUHA4mSX9EOmk/WrYfzow=
X-Received: by 2002:a05:6e02:3311:b0:3cf:c8bf:3b87 with SMTP id
 e9e14a558f8ab-3d18c210e0emr18520775ab.1.1739414444613; Wed, 12 Feb 2025
 18:40:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com> <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com>
In-Reply-To: <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com>
From: Song Liu <song@kernel.org>
Date: Wed, 12 Feb 2025 18:40:33 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
X-Gm-Features: AWEUYZkI_0_wsZZ0OwuTA-kxxA-vmhY8DCcstBAWLmULwI5omzh3gtrXHTioD-8
Message-ID: <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Indu Bhagat <indu.bhagat@oracle.com>
Cc: Weinan Liu <wnliu@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org, 
	Puranjay Mohan <puranjay@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 4:10=E2=80=AFPM Indu Bhagat <indu.bhagat@oracle.com=
> wrote:
>
> On 2/12/25 3:32 PM, Song Liu wrote:
> > I run some tests with this set and my RFC set [1]. Most of
> > the test is done with kpatch-build. I tested both Puranjay's
> > version [3] and my version [4].
> >
> > For gcc 14.2.1, I have seen the following issue with this
> > test [2]. This happens with both upstream and 6.13.2.
> > The livepatch loaded fine, but the system spilled out the
> > following warning quickly.
> >
>
> In presence of the issue
> https://sourceware.org/bugzilla/show_bug.cgi?id=3D32666, I'd expect bad
> data in SFrame section.  Which may be causing this symptom?
>
> To be clear, the issue affects loaded kernel modules.  I cannot tell for
> certain - is there module loading involved in your test ?

The KLP is a module, I guess that is also affected?

During kpatch-build, we added some logic to drop the .sframe section.
I guess this is wrong, as we need the .sframe section when we apply
the next KLP. However, I don't think the issue is caused by missing
.sframe section.

Thanks,
Song

