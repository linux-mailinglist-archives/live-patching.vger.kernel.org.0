Return-Path: <live-patching+bounces-1501-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C3F85AD0AD6
	for <lists+live-patching@lfdr.de>; Sat,  7 Jun 2025 03:26:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BAF61750C1
	for <lists+live-patching@lfdr.de>; Sat,  7 Jun 2025 01:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D490246770;
	Sat,  7 Jun 2025 01:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FfClw3hf"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA9BE573;
	Sat,  7 Jun 2025 01:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749259606; cv=none; b=hRd2AAYKEFJNC2IinWRLBWrFoulvg7Bg7FjHY8cAjyZO+BzPoV5cSnkDFudDSCTdLUO2lIcURR992zz/1/2cCs7NggyQnV7EhE+qcpqixw8aIy3ajeAHgqxPk+uQ+cxSuFAJcnofcneGgulFh0UmqKBYPuvb/m3gfCuYeAhGHzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749259606; c=relaxed/simple;
	bh=Yicz8GuFLGdAIAInCGG5pCMOCKe7oQT5Kcq9sOuZqKc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ACu6fei2KKE5E661NIG31Wohfv3G1QR3fJS3uMyvdh7AKpuApHzOOer010i2lcpcmjsWtgZo2lsugy9T1LVzVLcQvBjbiKwgENIH6nhdfUWxWIKTcf3obQc0oL97KYJm9Xp41A8Edcl68KZA5LaMIWarw2C5GmVMy6xe4u6b7ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FfClw3hf; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-32925727810so22494571fa.0;
        Fri, 06 Jun 2025 18:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749259602; x=1749864402; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mhPP6x4Dv0yG5ixt2jdVXYmQ6rdJ1bVbjB/DIb5xUL4=;
        b=FfClw3hfztR/nVzSD9rCDKCTKWeiRSoBcr/xj+jq9Pnr/4ExiiHIOgeNJiMh5MMLAK
         2iADefzrNidguVwB+yG4OJO3IdPU/tpweo4So2J0XdOYeXab76vB0xJMbgZ0ij6jiU5+
         aB4EO0ndL+nh3bLtL79CF/TSaxwFxUPfavrzLmcZzrqVtRH1jrL2jR7bHhn6ZQ2wTyRl
         8+3hdYfb6KPTNllaKBN66StDRlc3LOfU/aNqCw8nYre67ogRo7CEZJif3HGuM4B/g+3H
         RXFKrViOq0f0CmK1IOOnBdEZ2zuO+pfLjgsKteERzZCyYmutZLkTpMQEYsYTtx7JCG8c
         02fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749259602; x=1749864402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mhPP6x4Dv0yG5ixt2jdVXYmQ6rdJ1bVbjB/DIb5xUL4=;
        b=qaorb6EScGKoBJXhpT6vz648DksvRdZPTtk/vLu3cIthAR+UoGzQN28rZuS3vg/6LK
         OeTK8op9dwDlCuyEdb1v/fYO5fz+2d/MK1CrXaMXYC7M25OMZgn2eSJ5vx4bBa1oOBW9
         PFii9RYCxwDncC6IgB3cmSyhAmR9RH/fH1wuZiSiiwournQi7acII39xlNHgH1/sqftf
         6ai3o/kS5drc3y8/OXW7eXC/5Mt7LpxwW3VbrV4bCKg1QtKZqBO2aQNajY5VYmQ4HM0u
         orSaP8DcuT4zBH8nKO305TQy6+moIfvjbq3BHb97a8ThNYsj4LXTjMudD6rwJZzhHKfQ
         S6SQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD6bdKkgo/nXTVPkTkbpjTybrpMQv5FBZNLipWpEw0oj9/PsUldD/Q/RkPy0Y74o7RAxqGvcGUkBiGig8=@vger.kernel.org, AJvYcCVLM4JAGywGRMut1oNOGioKl0YEDP5YCwhocGJomNIXPAbzNML6UaOJwtvZhAzKFBHhlghICzFScyMAmOA7iQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yynw+0w3C3vG8+hg1K8eKZ98dA8yDw42hque/mtCmwlVKa6SzQG
	XNBgp7mFV+I9VQpJN+ykCzvKZNlp8mgJ0kbSIBAuKkUPYQJUhTlgWWQ0XPZkzLmkTw2KMGlFZle
	+lNazBCQNx4LP3MrshxQOsXKHBA9Xbg==
X-Gm-Gg: ASbGncv49+qbp/Izj+WUDISu5vWu0K411UL4j3pwjM7qHgq8sdDhfHhyW0AKT2Sc/I2
	O6w3N/rDwu7+cgWjiZBAIjoTWb37raWMhdU1Q23hgqwWvTp94lrqsQOYkJG8ur/R57+FVfXR+LM
	gd8eaJuuQdhC28ul+ysIgsU+y830XW5Ct+v+DAvXzKM7WDSew5KsR+/w0AaxbRLxf/9sif
X-Google-Smtp-Source: AGHT+IFClGnAxeAsiHdUAgpzUMgtBR1ZJfKzTrFqV27+pR/Drz7trMzxc9WvzMNtHuLmh/0MNFoVFWkChmuAPgTneHM=
X-Received: by 2002:a05:651c:2125:b0:32a:613b:270e with SMTP id
 38308e7fff4ca-32adfbd6680mr13621761fa.31.1749259602101; Fri, 06 Jun 2025
 18:26:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1746821544.git.jpoimboe@kernel.org> <198cfbd12e54dfce1309828e146b90b1f7b200a5.1746821544.git.jpoimboe@kernel.org>
 <CAMzpN2jbdRJWhAWOKWzYczMjXqadg_braRgaxyA080K9G=xp0g@mail.gmail.com> <goiggh4js4t3g54fpcs6gugmp26uoumucszrx3e5cdrqdl7336@qijkbpy747jb>
In-Reply-To: <goiggh4js4t3g54fpcs6gugmp26uoumucszrx3e5cdrqdl7336@qijkbpy747jb>
From: Brian Gerst <brgerst@gmail.com>
Date: Fri, 6 Jun 2025 21:26:30 -0400
X-Gm-Features: AX0GCFuHf8GgnjPOAdZ4H_TPbxnroj0Cb4HtVgwzVcOvyWsT-Cr_WKnpQT1bAmU
Message-ID: <CAMzpN2gmbgts1fFm2x=Ao=X-9g0U000+fPk_i7mMA-f0AQsQYg@mail.gmail.com>
Subject: Re: [PATCH v2 45/62] x86/extable: Define ELF section entry size for
 exception tables
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 3:48=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> On Thu, Jun 05, 2025 at 11:58:23PM -0400, Brian Gerst wrote:
> > On Fri, May 9, 2025 at 4:51=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.=
org> wrote:
> > >
> > > In preparation for the objtool klp diff subcommand, define the entry
> > > size for the __ex_table section in its ELF header.  This will allow
> > > tooling to extract individual entries.
> > >
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > ---
> > >  arch/x86/include/asm/asm.h | 20 ++++++++++++--------
> > >  kernel/extable.c           |  2 ++
> > >  2 files changed, 14 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> > > index f963848024a5..62dff336f206 100644
> > > --- a/arch/x86/include/asm/asm.h
> > > +++ b/arch/x86/include/asm/asm.h
> > > @@ -138,15 +138,17 @@ static __always_inline __pure void *rip_rel_ptr=
(void *p)
> > >
> > >  # include <asm/extable_fixup_types.h>
> > >
> > > +#define EXTABLE_SIZE 12
> >
> > Put this in asm-offsets.c instead.
>
> But that's only for .S code right?  This is also needed for inline asm.

<asm/asm-offsets.h> can be used in C code too.  Normally it wouldn't
be needed but the inline asm case is a valid use.


Brian Gerst

