Return-Path: <live-patching+bounces-1828-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE51DC27432
	for <lists+live-patching@lfdr.de>; Sat, 01 Nov 2025 01:20:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7B0D401EB3
	for <lists+live-patching@lfdr.de>; Sat,  1 Nov 2025 00:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A161C3C08;
	Sat,  1 Nov 2025 00:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cEVxPZQy"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C9218A6DB
	for <live-patching@vger.kernel.org>; Sat,  1 Nov 2025 00:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761956410; cv=none; b=tIAkvZ0y5tvVJp866ETF/eQBV6Sr6m7BYQsa6d0wpsFcpqxI+Caq9ekY2X2NxAJpvdJSZZY/bMkEFFZwyRFVEg0/8Gcukq1TxASa5+xbVpg/1xp/z/kjIbICakHzxWOHwoBEi57lbQUeBk7uSqD0n+PjghGRA+uq1Em3GjMitCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761956410; c=relaxed/simple;
	bh=+CLbNx0+SCLkDIniWRg4lwdqf5by9vfde27UuYHGViU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iedc/CvpHDir8mcaWhxzXKIdNI7OENvlfqkTIQf3anNWyrSJ+F/7P2XEtLj15qJE45cgontIkQuBkvAoHxkMZ1uBNrrGlS09QFCyoF0YTIRjdiYNbXgvdckfHkqCSy0u4uvd/hYvC6MyCmTMS8c4bjBIBzrmg7RJeQD9fauZeB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cEVxPZQy; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-429b895458cso1708830f8f.1
        for <live-patching@vger.kernel.org>; Fri, 31 Oct 2025 17:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761956407; x=1762561207; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CLbNx0+SCLkDIniWRg4lwdqf5by9vfde27UuYHGViU=;
        b=cEVxPZQynHD6EVYmi8B7DVKrmIX+D86kI5J1eyjbpM+4S5aqXmGZUHIeZi9HURHdSg
         NFbmizHnaM6aHfgpJ0nIAp205iBzeltylEEal3kF3wqgnAIlD6PALzd1W+DxvYZCBulb
         oWTvxbRXUn5VeL+iW6WuD8HfAZHeTR0Fcs0TH7hpA30cv4HBFAIFQte2Z+MnISfhpsvF
         q9AVlnzRKeFZLa7YtxXezTRCCryEnb5rvjCrwk0b00eWOvIN1nR2UM7QKVBpglByX+m/
         pNqa2Zx3kVFOBftlpMi+IfIrs73JB2O96RY5iYv93inZ21emikzS7Xxn6VZrc06A/3Ys
         tE/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761956407; x=1762561207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+CLbNx0+SCLkDIniWRg4lwdqf5by9vfde27UuYHGViU=;
        b=NeGk7b1HZWjE09tqNIWnoDXg8gGTiqCYTbEKYHIf8vGQWYCxbC09uwaixbwXTjoQXc
         cAXaJXWxQBaekhRTYfHs8HnXmJuMyy4cezu73ukf3dC2NpRgAvzbNcrBnznKyhaf0qwR
         HItJIi7PHilIMde2e5tMABMc0u6eVqRITfB/2/EO91sGTWytGjjoz8JpZe+TfEbahELW
         f1pMBv7BpaHGS8vM8qK9FTqg5YIUXjjAEMEFYtLnVi/CH0J5xhwkM4g6A+V585xT+wB8
         ohxM+G0ruGfxlz9VLuPZD9Iu9I7oNCvhvplqkq8dkjMU8ZdmQkdxsmPFuY17DA7OALE4
         Q1lg==
X-Forwarded-Encrypted: i=1; AJvYcCWc5V+JxXEq1owAlr1LoYunG0vsKgQoHfnAO6289T7Mz5tyK0SsQUGDjYX2d2VLhT7OKI9tD+TtjyCaivkD@vger.kernel.org
X-Gm-Message-State: AOJu0YzC2bpeH+c6+dNx2P/IplkOdr5AA1cnjlPUFmpvdg/q2gwtAhzQ
	MW4NyhkBRIy2zBNBO+e2eU4wLj1VoCFc+t6EG9ZB1ebXXJUyRVyRSP1PtgZBbVk1bEjWdA4xY4f
	GyBdpAywwGdMzHNd70Gkxr7qhMWO2ALo=
X-Gm-Gg: ASbGncuF/VE84Jb3x3NNs8lEd+ZrhAaTLNqz3xOB5/9R3v8AlN9tuZBSTiW47H3MaCy
	azb4kqmnkbK6IZBxm+971zu59yeRdsv5e63Xy/kabinqDAU4Op3HCPWRjB7jAT7RKQoyaRfG/Mm
	5szG1Q0XlaHEEJJk9j8LRcehkU+dT/T0gNXnDrDz/Ikx8+6oMiXsr4O0PbWUrOAvqmRNC5kYi5Y
	ayC6CtU0MDqTVj7wjbxQbsPRrqgUgHVDkoDnif0Cj4cxk//KkKXNYgR3NBb9OcUGSVopbXb6df6
	oDTNBbc/gDMo/X0Smvb22OQz8VtT4//+U0imRC4=
X-Google-Smtp-Source: AGHT+IHNYlEWOUMUtDvrTK4geQQrmMKnQJBQrV6hcEirA2F2JhOkgWTEMrJG0KJ/zrGB83nhreewf0v0Vbb+Cn07cBE=
X-Received: by 2002:a05:6000:4283:b0:427:8e5:39df with SMTP id
 ffacd0b85a97d-429bd67bd2dmr4146048f8f.21.1761956407306; Fri, 31 Oct 2025
 17:20:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027175023.1521602-1-song@kernel.org>
In-Reply-To: <20251027175023.1521602-1-song@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 31 Oct 2025 17:19:54 -0700
X-Gm-Features: AWmQ_blwHGysxMuw7rx01dYjPj9zdTLkr7fwqsaiFUdesnwh3GVJuzrF-PEto30
Message-ID: <CAADnVQ+azh4iUmq4_RHYatphAaZUGsW0Zo8=vGOT1_fv-UYOaA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf 0/3] Fix ftrace for livepatch + BPF fexit programs
To: Song Liu <song@kernel.org>
Cc: bpf <bpf@vger.kernel.org>, 
	linux-trace-kernel <linux-trace-kernel@vger.kernel.org>, live-patching@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Kernel Team <kernel-team@meta.com>, Jiri Olsa <olsajiri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 10:50=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> livepatch and BPF trampoline are two special users of ftrace. livepatch
> uses ftrace with IPMODIFY flag and BPF trampoline uses ftrace direct
> functions. When livepatch and BPF trampoline with fexit programs attach t=
o
> the same kernel function, BPF trampoline needs to call into the patched
> version of the kernel function.
>
> 1/3 and 2/3 of this patchset fix two issues with livepatch + fexit cases,
> one in the register_ftrace_direct path, the other in the
> modify_ftrace_direct path.
>
> 3/3 adds selftests for both cases.
>
> ---
>
> Changes v3 =3D> v4:
> 1. Add helper reset_direct. (Steven)
> 2. Add Reviewed-by from Jiri.
> 3. Fix minor typo in comments.

Steven,

can you apply the fixes or should I take them ?
If so, pls ack.

