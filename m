Return-Path: <live-patching+bounces-1201-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0FCA3657E
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 19:12:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 952DA7A6647
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 18:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87151269807;
	Fri, 14 Feb 2025 18:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZ4ckviD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2402690ED;
	Fri, 14 Feb 2025 18:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739556643; cv=none; b=O2TN9J5Bt3OCSBeoZebKsKQ8WIwGHuYM32Q6yRLm0heyvo4TMrk7tjqdRDtGM+YyT/yi6tpr33ErLBKswjR269WeFF0zkghsbSMN7Q/IXuGujO/yGDu3oUULxRkzKi9vxbrA4xwY6H/ZJr/VwLHuYL19R7bBBm13H6lu/PM8V5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739556643; c=relaxed/simple;
	bh=qsZ3M7HjZdTjo5f5WrSVbOZM9SW596Y6SP7V0X9VgQ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=utGzZqnjyW0RgRItz015M8vGLIhG5IYEHKe5WWl4ns5F5ZY8CSi+og81FzKV2k4TFbr9RaCrPcfz4cow7sWTm4ic2pnOvDjPFSun1fiEPbs5AcbrWgdo9dB8D1WF7I/V/NbKny8xx5pB+STBDnwvLstF1PQXD84yAZHrBIhWlyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZ4ckviD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE448C4AF09;
	Fri, 14 Feb 2025 18:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739556641;
	bh=qsZ3M7HjZdTjo5f5WrSVbOZM9SW596Y6SP7V0X9VgQ8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bZ4ckviDNzJRoX58jtuwMBbs3xQ14eqGG8zrnD5z2qhjAnWh7XAbqnv24/noOLgLu
	 olEqflJMzBqxLIEUyMVH3F4JxPU9p/38924gRExVw4lASKGNfh4Y0RKowlVmoMp+y9
	 WrNx86OLMB/QPjzgAASBK3Cbi/Pz21kAMqpUQNneKoJPJUQ4/2UWGhc/0tYX1Ms1zp
	 eB8cqCL00KIgU7sdFtDTngq0t2on1bw6LCWt1GzyeaCQkPVYQjfQv/nOu4ib+I40lY
	 neKX0TUZmlPfSyUhUPHyxMw+0W8iXRWqAGjUL7JJhuY6e8NptBhrP7LztciXGJRnoD
	 OdYj8zyXXbjPw==
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d18654e8d6so17688385ab.2;
        Fri, 14 Feb 2025 10:10:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU7T4+v5D4WCoJlBLnJ/0yPrhXNAm9893daDVUfLpRkewxsA7iZjQF6A+f3Qd3OPrqWg/Oxu8oq0nzIBGe5lw==@vger.kernel.org, AJvYcCV+HV9PdLRDRGYorpaTxTDIDaifGmvv0idAAzlN9b02u59ocGJITqvsiOe+vUPLsHAwZtKR2PJVy9TiYOA=@vger.kernel.org, AJvYcCVV7APkoCgPCFjf3E9j8hyQPiHg1j2FxVqUBkVN52/MbPTIo8Ma/LLPjis44FQZHclKAj89ABZuR/j6Yb7ZGopn0A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7vZXdkUhAlFYM9GgpJwETlJFfPn+RXLAWWN92usJny2bD5ZEs
	JOz3gY0iHr8LOJtwcdKzT7u9otR1prqaJqAHbMFA2qCu8EIHCO1DJWOIpLWahljcllGBMasRVt/
	FkGrFNl/nBDfskSs0YLZwIOr35Dc=
X-Google-Smtp-Source: AGHT+IG8JZIw5oJUYOuAL23YnIRiuk4cQKNQCcLNAYc2hmGsxchwTn9wwIBLREFhDO96qyScsuyGb1CQAAe2KZkUZEM=
X-Received: by 2002:a05:6e02:3103:b0:3d0:4e0c:2c96 with SMTP id
 e9e14a558f8ab-3d280771b4cmr3760875ab.2.1739556641173; Fri, 14 Feb 2025
 10:10:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com> <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com> <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
 <mb61p1pw21f0v.fsf@kernel.org> <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
 <mb61pseoiz1cq.fsf@kernel.org> <CAPhsuW7bo4efVYb8uPkQ1v9TE95_CQ6+G3q4kVyt-8g-3JD6Cw@mail.gmail.com>
 <mb61pr0411o57.fsf@kernel.org> <CAPhsuW7fBkZaKQzLvBqsrxTvpJsfJfUBfco4i=-=C_on+GdpKg@mail.gmail.com>
 <mb61p7c5sdhv6.fsf@kernel.org>
In-Reply-To: <mb61p7c5sdhv6.fsf@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 14 Feb 2025 10:10:29 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6vDYjiy1_tOhy--ULC8UWtpu4E_nd8uY8qg98eLuygQw@mail.gmail.com>
X-Gm-Features: AWEUYZlpNf1avV1LJZl1tk2itoEk1uL2WdB4o2NSm5faGZWiZiU7f7T7DB78KCg
Message-ID: <CAPhsuW6vDYjiy1_tOhy--ULC8UWtpu4E_nd8uY8qg98eLuygQw@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Puranjay Mohan <puranjay@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>, Weinan Liu <wnliu@google.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Puranjay,

Thanks for running the tests.

On Fri, Feb 14, 2025 at 12:56=E2=80=AFAM Puranjay Mohan <puranjay@kernel.or=
g> wrote:
[...]
> >
> > I am really curious whether you have the same problem in your
> > setup.
>
> Hi Song,
>
> I did this test and found the same issue as you (gdb assembly broken),
> but I can see this issue even without the inlining. I think GDB tried to
> load the debuginfo and that is somehow broken therefore it fails to
> disassemblt properly.

Yes, this matches my observations: gcc-11 generates the .ko that
confuses gdb.

I tested with two versions of gdb (10.2 and 14.2), both have the
problem. OTOH, lldb is able to disassemble copy_process from a
gcc-compiled .ko file properly.

> But even with inlining, I couldn't see the warning about the refcount
> with my setup.

This also matches my observations. gcc-11 compiled livepatch
works fine.

Thanks,
Song

