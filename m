Return-Path: <live-patching+bounces-1865-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C06FC66B2C
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 01:49:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BFD7735191D
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 00:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644562F0692;
	Tue, 18 Nov 2025 00:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGB9NgQN"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7DF212549
	for <live-patching@vger.kernel.org>; Tue, 18 Nov 2025 00:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763426961; cv=none; b=JnxGB+lnDeu6Zgm5WYsqmmcK3br2aLN25CLbeVPsf6s35AeFIeKPUF4HDeeiyfnsDDUlSj+PBDOntJot6iloxQcuYFwXqTI4peMH9S+1HZ4kYwtgKe5R0z5WnhZh1neOcNbKc2o6JMKGXNS8cqgAXpC6QiLMyAv/3Wmor9q5Zos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763426961; c=relaxed/simple;
	bh=c732cM395vY9+1JTa2O20pqSKFeYB8L/4p2Yt1vgqqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ChxFdW6IEKKeTgTcSx8P/hI6KnRbGlgj+8hZASsbs8ph/mxfeh4XOSHwPygIFz/SobcbA+L6YaUyfTjjGnZJFn1y3JznsvMQt1ldV2CYFz3LKa/Q55UOIL361xUbNTx2F+p5ZBzY/rch15dHzwh4TuJfIJfgQizxBqsoDCx7wdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dGB9NgQN; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6431b0a1948so8644894a12.3
        for <live-patching@vger.kernel.org>; Mon, 17 Nov 2025 16:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763426958; x=1764031758; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JCWbJW+VyaCqJDXn8I9OGBHB03u1kpUR2PiHOuHq5w=;
        b=dGB9NgQN4urZB3mi1bQAk5YaSKDPMntdL0MEx6DdKLXNKCRsnAWi5QeVdyUIUnN3hD
         dmkcs1KTBisSJNdzl/0cdZcH3vK7vhN1eenrV/I7fa9lXTLKE9ZLg/eVNslI0QCRiIGT
         83hYdBIFhy94V6SyQNdN2R6yOnLBPumwUIdlROhGxdHKMOniE7TmOkZEvFnpae46+ysS
         NNS/FuKrrYDLO8YtopqS09gWbdtdeaqgLfSO0NOiD2lQGeY+HgIZB77ld6IVgNPPfBmi
         NCSv5s24SunlVPsTq80ztGtwVFpsw58/FS5PDtI/AIP8QwsN23YTroyRfTckkkg2hAwc
         L27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763426958; x=1764031758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0JCWbJW+VyaCqJDXn8I9OGBHB03u1kpUR2PiHOuHq5w=;
        b=f71Vq2uZsxwG7kLNYgwapTo0ny4KVeokzicCUCWGszVle7CCAPZSGG2BWKaPTtDPrO
         yFY4GJDh1bDxFuN30NY9/nnJPWJ4VCJBjNh5yeQWlqkVZ//ju8uq5ZJYbWp5ihvFKh69
         WYuqN7WGpnnw/GiH/AooVRsjtuWzwYGzUBia+zQyQ6EBozGhqr9Sz3CM/oYCsXKcXx7e
         anfhzjMklM4yDneOVUupbDYw8uLY4xe31Y3VrhUHbD5sTbHxOpfXwdshyL1Y4vhvPD+t
         C0PlfZu59kxKR5/l33XenmZDCbTa/qUT5+I2XCp2Hf01FlTtNdCpY+yipqLA3bFmEBTk
         k0xw==
X-Forwarded-Encrypted: i=1; AJvYcCWbQhepHu725/CLIWzp0ui4SkcsbbZzjrR/34jo1dGmArRPdTsfkLezMgpHbV7EC1O4IiOTwEi1f6YuUCRF@vger.kernel.org
X-Gm-Message-State: AOJu0YwbIUxz2NjJXeMRFSvh4FFpfQXdS7VMvqOBKtroBAMMEWkdMU0i
	t2CcYuKkyEICytazjHK8jKqtKLD0NlYxbow6ZuWBBfDyGzVgzH+oIqkb6MCCwJlW0A3Rsshsm6h
	kIunZXowiBa5j+2GseQhZGXdRKLXFhtw=
X-Gm-Gg: ASbGnctapmuJyPe7GqxffUmbNt6dmJABSq11PxaZyQZn5q1+V/ZlGB2Q8BEbSVv/p1Z
	iR4dVnRdntVgQpgIwfEgTnMu/87U3CswhfmWyTQUfcDtlPNxlZuKSfbcgy0z33XmObv1EpA6CEE
	ubT+ivgtyDsKEuhG99WPwQJ01Rl+EByT3EUSVr8BZV1N6mEHLCiYk4900DNCjI/kG/BorQcX/JU
	xtr/enS2WGF9nSISkqqMvi0Pu1oigKrsiSqXVtb3LR85yBWKv/pmvCzjJi8et1LcZGKIT7sU1AW
	7DvjzKTWfPuDrEZy95hVFMKj/fo=
X-Google-Smtp-Source: AGHT+IFYhNSVw+lVlppb6gkSkeUMosiTWUKFJQ1Pxohf3WiRYuN7oeUtHTQkIRN3bZJubf1VlJXyj0wFgI3FtAEFjq4=
X-Received: by 2002:a05:6402:42d4:b0:640:b736:6c2b with SMTP id
 4fb4d7f45d1cf-64350e9ff08mr14053239a12.28.1763426957573; Mon, 17 Nov 2025
 16:49:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com>
 <CANk7y0hUKOVXRKoJ5Ufmg-5DGSe2F5nBH+O7tLVvLRs9Oe54uA@mail.gmail.com>
 <CADBMgpwZ32+shSa0SwO8y4G-Zw14ae-FcoWreA_ptMf08Mu9dA@mail.gmail.com>
 <nzmtsafrx5vjitgfpducjaa7kq747a3sler2vvyvfbxecutn3v@7ffl2ycnaoo2>
 <20251117184223.3c03fe92@gandalf.local.home> <cxxj6lzs226ost6js5vslm52bxblknjwd6llmu24h3bk742zjh@7iwwi5bafysq>
In-Reply-To: <cxxj6lzs226ost6js5vslm52bxblknjwd6llmu24h3bk742zjh@7iwwi5bafysq>
From: Puranjay Mohan <puranjay12@gmail.com>
Date: Tue, 18 Nov 2025 01:49:06 +0100
X-Gm-Features: AWmQ_bmWkRNgPhk0mYiP_-e12vjTcFyjQDEWgQeC9hhlwE08B-nrey_BY1JAiDQ
Message-ID: <CANk7y0hKH6vvWf3Lyc678uvF9YWStMzO-Sj8yb3sbS4=4dxC6Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] unwind, arm64: add sframe unwinder for kernel
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Dylan Hatch <dylanbhatch@google.com>, 
	Song Liu <song@kernel.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jiri Kosina <jikos@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
	Puranjay Mohan <puranjay@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 1:10=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Mon, Nov 17, 2025 at 06:42:23PM -0500, Steven Rostedt wrote:
> > On Mon, 17 Nov 2025 15:06:32 -0800
> > Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > > The ORC unwinder marks the unwind "unreliable" if it has to fall back=
 to
> > > frame pointers.
> > >
> > > But that's not a problem for livepatch because it only[*] unwinds
> > > blocked/sleeping tasks, which shouldn't have BPF on their stack anywa=
y.
> > >
> > > [*] with one exception: the task calling into livepatch
> >
> > It may be a problem with preempted tasks right? I believe with PREEMPT_=
LAZY
> > (and definitely with PREEMPT_RT) BPF programs can be preempted.
>
> In that case, then yes, that stack would be marked unreliable and
> livepatch would have to go try and patch the task later.
>
> If it were an isolated case, that would be fine, but if BPF were
> consistently on the same task's stack, it could stall the completion of
> the livepatch indefinitely.
>
> I haven't (yet?) heard of BPF-induced livepatch stalls happening in
> reality, but maybe it's only a matter of time :-/
>
> To fix that, I suppose we would need some kind of dynamic ORC
> registration interface.  Similar to what has been discussed with
> sframe+JIT.

I work with the BPF JITs and would be interested in exploring this further,
can you point me to this discussion if it happened on the list.

>
> If BPF were to always use frame pointers then there would be only a very
> limited set of ORC entries (either "frame pointer" or "undefined") for a
> given BPF function and it shouldn't be too complicated.
>
> --
> Josh

