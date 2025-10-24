Return-Path: <live-patching+bounces-1801-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2387FC075D1
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 18:42:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA9AD1A6381E
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 16:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF6A8283686;
	Fri, 24 Oct 2025 16:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTJ9IHeO"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D5E2264C4
	for <live-patching@vger.kernel.org>; Fri, 24 Oct 2025 16:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761324159; cv=none; b=I4+KcAcdjNmhqlll9SzLu8moV0RADcJn9wfHCLGjj8SM2TRtaJuucN2fuaCeHjFW2J9IQj8hcrcksN0gCm2JTvIUjVeJ8lFxcTcYYu5amrQ4MndFKc2+S1bKUz9REEBodnJ3OLiuAoB/SHHRdA1M9N+J2dYSJiLPsFzaZmp8GRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761324159; c=relaxed/simple;
	bh=yXM/YRks1kc3xYPDJ+DL5Ms/ov6faB3xqdY7FQmVqBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CpvJsq46j1uaaEVqcvxJnnmVftHtVoz0rbcK6n2bcXNDvObsjOEqjsBpkFBLwv21d3c5ltTBHsBoN7WH7ch+qvt25iHZki9dYGmi3zaUQq2IJAgLzH12b9AgNQUp0tZszKMUC73xTipdvOFDAiuVMIoJJyKEwrPhkyV0BwwEbfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FTJ9IHeO; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4710a1f9e4cso17761395e9.0
        for <live-patching@vger.kernel.org>; Fri, 24 Oct 2025 09:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761324156; x=1761928956; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yXM/YRks1kc3xYPDJ+DL5Ms/ov6faB3xqdY7FQmVqBA=;
        b=FTJ9IHeOdrrjFXhEgu/jP19ViNTj0qu4lU3N7INJt65B4WivWHh8m6B15oJX03GQse
         ZVGUJNuXHgmD8+VvRHM9p+WcUvcFRb3HNXJNXzf6MJjF5K1nFsETUpzl3sWBPMGCK70s
         kVEO1uGMT5nGQlTWnaOMKDmamsZeSV6juvBBCTdP7cKeP8ufRvs61/ymJxae+MAZK/dV
         BkGjrSad8pGjYOgrkYl2vND8bMnjSnfXKvnnqeR7ysQceHGJUcHEQdtZrE8qdhDpU20k
         G+PWm9HNwH0AEUW2LI93UTaE+5SfTNGgxSFL7HIc4Db9jKjrfVpEdW55cvKz+VHmV6vu
         dppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761324156; x=1761928956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yXM/YRks1kc3xYPDJ+DL5Ms/ov6faB3xqdY7FQmVqBA=;
        b=WkQ4Ir+btq4i5fzq72eStUewbWST8GQEXDK1YwSJuwrV7ZZCwe87nXPerJe+mDWwGZ
         Aj2e9cXuFb8V43DT7Zrxo+foTE4onpzZj+bGIE4jxgVuSOOkOU4XyNZNykJzq/kzFowq
         QBvnpihNFKNZ9kvRk3rzfehdntjsIiXlFg6UPkyu/NgJt7bdzsdY3ATKBkA9+g1EC0pQ
         po4wZpmny4f0p/MqUuAGpb0iKpYANsd1goOAngV1UMj7dOX7vyLvjLkH1gXdEd4wqwxP
         Ht3TX6C1MBPqCT2tlnzAPG6N0DzeNMXasKNvVdsOglFhxJ1sPV9gDmXY/By38lfO/9Cz
         KxEg==
X-Forwarded-Encrypted: i=1; AJvYcCVzwrb9+6HBNUg5W9Z3k+96C+/1T4yFJ5pOmnNmwnxNsK0y+ZWxshYmxOXnFRfU25l933i2OIwmUO5DNLOc@vger.kernel.org
X-Gm-Message-State: AOJu0YxKUEPaBedhu3P19TQPLKPrInXrMv9lM+bPkbFa8XL9WASv7l7g
	elhwA8NRaJpoeSSbgleR33bvUR6A5m5vsUsRVWTqSD4JXOIDyHVwyo6bw8+PSexTXQQo1Cp/1WK
	qFkIoMdsyO+xxyeSlEDBFhWXJH327pMU=
X-Gm-Gg: ASbGnctvpI6GOMiAdtTw5Y038yj8iSiXr2btLyyBV4Uawq8sZ1pSdJ3Wu6PowSkW6yD
	dRO8mIbmIc/JkLuianpw/PIeF9IH7R5GDl1x4JQ1zJbojUzqcAS/RNZptfPEBw1bu0oMW3jdEVs
	UBfagTSpYllvB5Qrj96wFtZn1CKsyXqLvPey8vu7MW8/AJ2N25PA9utVrhi7dmQHMAgccZGpC/r
	CtOLc5oRev/BWS09qXiZXKFE8K2ILADxKebI/RzPwz3dDgxbfGbew66izniooMnwkKUHEfJ9T0a
	/wCfkKilS/O0ZV3n+w==
X-Google-Smtp-Source: AGHT+IH5nqX51vYu1IexzHdkNZ0afoJ1pJcMt9JtXykhaYOJDMZrIHUFWcskwHmjhcu8uYAf0gEL402Nx2zXqhGVX2Q=
X-Received: by 2002:a05:6000:26d2:b0:429:8a81:3f4d with SMTP id
 ffacd0b85a97d-4299075ca93mr2745229f8f.63.1761324156212; Fri, 24 Oct 2025
 09:42:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251024071257.3956031-1-song@kernel.org>
In-Reply-To: <20251024071257.3956031-1-song@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 24 Oct 2025 09:42:24 -0700
X-Gm-Features: AWmQ_bmjZ0ZCnr-m8vmqb1yEUfyIazFF0Pj2kGjJ8zWuivBt4mpAdBnhmJLj6R4
Message-ID: <CAADnVQ+fJZAHKBz6aVRBLjMyxbF2wZusEfD+AihN+9RWvrBwtg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Fix ftrace for livepatch + BPF fexit programs
To: Song Liu <song@kernel.org>
Cc: bpf <bpf@vger.kernel.org>, 
	linux-trace-kernel <linux-trace-kernel@vger.kernel.org>, live-patching@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Kernel Team <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2025 at 12:13=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> livepatch and BPF trampoline are two special users of ftrace. livepatch
> uses ftrace with IPMODIFY flag and BPF trampoline uses ftrace direct
> functions. When livepatch and BPF trampoline with fexit programs attach t=
o
> the same kernel function, BPF trampoline needs to call into the patched
> version of the kernel function.

This sounds serious. Pls target bpf tree in respin after addressing
the comments.

pw-bot: cr

