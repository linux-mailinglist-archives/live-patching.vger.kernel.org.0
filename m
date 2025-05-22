Return-Path: <live-patching+bounces-1452-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B682FAC14D0
	for <lists+live-patching@lfdr.de>; Thu, 22 May 2025 21:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1B2D3A66B5
	for <lists+live-patching@lfdr.de>; Thu, 22 May 2025 19:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E18205ABA;
	Thu, 22 May 2025 19:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UF0ifT+y"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30497083A;
	Thu, 22 May 2025 19:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747942157; cv=none; b=SVyxRHj4FRDF+VUd7xdUsHpaQ40DGw2uzE20I/nRr/NxiSrSfGvownkNSMhIZWLpIMa9d745OHI+Ds2x6B8IvdmL2OUudl2XKsRusCRCy34Bf9Cx7Ix+lcAt8lcTFQj0N3F3VrB6Km/R3GUf0GqcwcvqnbUgoYRIidq3aIXFRYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747942157; c=relaxed/simple;
	bh=VTQ1sOp3emeRBHQnf/LKwayGmF56J10umRqQ1zOkHuo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D0PaBBF4yMzITDHIqIgt2Pafw5vXO0CjDkLIBv3TFFkCNkFeQaSeHJK927qW4y21kRXqalWGNmcH+aQX0ltI/oCiD1aA/QPaIGiDa3TgSPSM8/2NbPs3ppj+mt55pBgTljjgJGzyk4jOZIDeHj3RJNcwmGRLkGYLwYgUu+aWB8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UF0ifT+y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3855FC4CEF4;
	Thu, 22 May 2025 19:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747942157;
	bh=VTQ1sOp3emeRBHQnf/LKwayGmF56J10umRqQ1zOkHuo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UF0ifT+yPGipUqRwatAPxXxUS1qjhektWWKkqXlvbMCdwDGPhEFenTgcA2AkMLKH2
	 0WClS46Pfb9QbGX9AM3JQlQ1OPS3Ixedi1cairenbBP6+fUYhVvDao6kdSTrXZVOgw
	 qRVmvfRLAn5IXoKIpOZXy26tVxwo066iCYFx5o70OFAOPQ4ZAz8YmJ6usEJ1TAU+4U
	 Gn4RE1ksvLCLLmpV8tq0ROhkX64Z5duoL5kQgsOBa24+VTeEOtIjLxim6Szdlo/opG
	 GKYw+IlQK5UPFBFL4F4uHtvBw79wIzHtpbZkft99XCiw/Vzqs30Op07BFVSQ9fcItV
	 iFn2QrjURlaJQ==
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4766631a6a4so86142781cf.2;
        Thu, 22 May 2025 12:29:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUN/f4TSw+I3larpyyj+s6aAVpLdk0ourAUQj0W7DMq5Kgkn16R02vHsMqqdVdQ+VBiBv46c1Y4nzlcp0M=@vger.kernel.org, AJvYcCUXtYEjcc1Q0TG2DzBDczzPz9/jpwhfuMQy8hN69+wAKCZD7mzmSS/M4CTDTQHqxslJ7Xy1rqUeMlGdqYlGpQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ6HMXOCxmydbcFdRm4gM2oxkuCrdyHSKfTgIcnJRYjVdzNRk0
	1csWvTQJR/OPEGLMv0hrmb3jxwd9G9sCHRZY6J0BwgYYtMPC/yNIVoT/2//L9NNODO3S+4hsZp6
	RqAUKaHApac31Gsxnd4mMlDy0nRxEAgc=
X-Google-Smtp-Source: AGHT+IHxoucucHwQiQ5k+QlgHbE2CP5qSpkJS6DGAZHp8GwQn8AznRtvdzBRm9o3lXbC6hZ3zyegkI2oQ1ANI3VBptk=
X-Received: by 2002:ac8:714f:0:b0:494:b8bc:8adb with SMTP id
 d75a77b69052e-494b8bcca9emr317745361cf.5.1747942156330; Thu, 22 May 2025
 12:29:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522184249.3137187-1-dylanbhatch@google.com> <20250522184249.3137187-2-dylanbhatch@google.com>
In-Reply-To: <20250522184249.3137187-2-dylanbhatch@google.com>
From: Song Liu <song@kernel.org>
Date: Thu, 22 May 2025 12:29:04 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6=kz5v2fBC2fwGXSG3orRPuDf4qdh1ZsLBfQNn6Zpi6A@mail.gmail.com>
X-Gm-Features: AX0GCFsoCb4olxuchinpzxOR6O-IyGNTRm4ViSFvjwWy9gpvmYeUfBQw7wSB5O8
Message-ID: <CAPhsuW6=kz5v2fBC2fwGXSG3orRPuDf4qdh1ZsLBfQNn6Zpi6A@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] livepatch, x86/module: Generalize late module
 relocation locking.
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2025 at 11:43=E2=80=AFAM Dylan Hatch <dylanbhatch@google.co=
m> wrote:
>
> Late module relocations are an issue on any arch that supports
> livepatch, so move the text_mutex locking to the livepatch core code.
>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>

Acked-by: Song Liu <song@kernel.org>

