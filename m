Return-Path: <live-patching+bounces-1898-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 621A6CA4063
	for <lists+live-patching@lfdr.de>; Thu, 04 Dec 2025 15:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7699F3044685
	for <lists+live-patching@lfdr.de>; Thu,  4 Dec 2025 14:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F98831B10F;
	Thu,  4 Dec 2025 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SonUgAeH"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EFD3054F2
	for <live-patching@vger.kernel.org>; Thu,  4 Dec 2025 14:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764858461; cv=none; b=lNjtc/BCdiwkNLbJF72T0UWMM56Sdtu7+EaM3gY73NOqR0OR1RY120Wd7y8KoXN+w0gxx83kUEUJQXpdOOOdAWU8kIDI8xZWLMUDLRGJUscY8nyUntfTcQFrNT0yhazdeVjjybU8n4jil+DYVzQSVwihXldQoKQte0w8N2SfoXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764858461; c=relaxed/simple;
	bh=ogzhs+K8/nncQzYMAXtApIYDNbrH0JpnISXUE/QTmCs=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9ec62Vb7wpA4eqg2PHc02cZFxa1dethE+aEBOgmh+ZrtUw3k6W98rc7Y6OuGo6VoMVc5xyeqjGmq4PLXLT6xd74DvbRS8H+ex2mpu/U339amGEXxZPtUi8X8WulOa5BMFR4k8LuUAalUii703Ij5oiPTwCPe8fGhjhdR94tUsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SonUgAeH; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42e2e2eccd2so732872f8f.1
        for <live-patching@vger.kernel.org>; Thu, 04 Dec 2025 06:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764858458; x=1765463258; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8OQ1axH1q6YiDBepsExxh/kCsQ5we62M82u0CfkZBOI=;
        b=SonUgAeHCcEa7Nb3JT4W9cZ2HoB/2ll+TFeaOdCRaQZUS9GpfkYkk0bvwvnGeyzSEe
         arqDIcbuAoXCpZwU0UL1h6LIqk9w3aNcMeI+YvIuc4FdGXXS9IA3N7Vk82Whu69cXM04
         JtWSbNyjy2ldE7gtJmrh9HPtfn1pZH8iUojf3LAt29lq2rqNaJobGF9aMpFzOfMhDZoK
         yZoASd0WTnbhc6l9HDgweIns67yOUGvKelQKGkpD2+3q58WGx3Vr+1VzVRQnoT4tPsbp
         ExiFDFyWTw0sJCHX1cM93pOZWeL0QX5NZT+71bfWIiXu/tlo8nOo7Ek9vD3Kr6XedaXn
         479w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764858458; x=1765463258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8OQ1axH1q6YiDBepsExxh/kCsQ5we62M82u0CfkZBOI=;
        b=iiUF5NIUONjXBGojw1nR9XeV+dm3bzGI1/saWxFI8D/uvfkXqan3uQHRPY0rUvHjZV
         slquWfGivu6DgmtvzrZxuHGe3L/rmSDxFpM6zD7BSzmRM2c3RmaEC6UCIJIjVuHrJ5RX
         ARc4c3/hE4O0C7P1UFTPXej20Kl9ghffbADu6ZY/2iOHM4vOAxrthripuAGUZrnRc7b0
         hixdQsnMr69wJ35QX2qRb8gv81eCRYhsoYULn+g4VQiHR9dJ6qacu0LEdzfAJTDjbAhn
         HkkSB2DGVeVlIXheQVC8eNbXQtZijNUkL7LJiUaO0xuF5HthjI7wm/8S9hq2KBNZ9E34
         l/sg==
X-Forwarded-Encrypted: i=1; AJvYcCXdJZ4Qq1XxbXyqrMONjg4DHXYyCjsNMdBzST7LfPlzMF36px8xcGMPs3/WJogX5XW1qmIjY9z0IYg8gtdd@vger.kernel.org
X-Gm-Message-State: AOJu0YxiAVxms85XVVWrnBEL18saLZydZtKBH9VlJU3xtExSYuSUvzs/
	KoUTjQm74RNo1MMyLsyn6+WIqeTD9YvAhOV8PRaMtIzGbo/4zMaAn4g0
X-Gm-Gg: ASbGncv/G5+N7s+qdFsoGW9nA+OSVPaKCDtjVbTg0/hLofquSIYNhkMBzpYcO9raoST
	vGXTl7s0jQoAYgwP2vuK7dblLMiCePjX4sFJRUzV7zAVepaYgvKIiE1oS1zXrm3/noxIlQVtEi/
	XmGb6btrIjivC6lYqjUcfhabXTb/ZKvvKpHeH6zpOjlGE1zQAPdKATrKzMn/iBj2aEDluVPk1M1
	lJbmJdiQ7alTmiZy+X2e6amyXMvruBwY55GGG+DJNVcsO0qCd9DAyrVpwbMwPG+k386VDmqdLqN
	eftJpi+k/OaNI0tHL5NLzqTHLQlYWG+Qa/ZCgwMoOx+EENNfbxD1yorIIqPbAA8JOLs9zMlbUw+
	8riUHI/Ecaz+hDQz0MIrmwIfwy/UCrGpAdkbnuyQWvHm17XUU714M/WscWKVE
X-Google-Smtp-Source: AGHT+IFnQQ8becnEaTn0KTt23OR8N4k5GgFAhsktS6Tsxf/fO9l7JvekT4rS8R2skMQ7eIQ1nU66aA==
X-Received: by 2002:a5d:5d05:0:b0:42b:3ab7:b8a8 with SMTP id ffacd0b85a97d-42f731727dfmr6824903f8f.17.1764858458166;
        Thu, 04 Dec 2025 06:27:38 -0800 (PST)
Received: from krava ([2a02:8308:a00c:e200::b44f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cc090bdsm3444201f8f.19.2025.12.04.06.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:27:37 -0800 (PST)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Thu, 4 Dec 2025 15:27:35 +0100
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, bpf@vger.kernel.org,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
	Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>,
	Raja Khan <raja.khan@crowdstrike.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 0/2] bpf, x86/unwind/orc: Support reliable unwinding
 through BPF stack frames
Message-ID: <aTGaVw005i8-Lb3L@krava>
References: <cover.1764818927.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764818927.git.jpoimboe@kernel.org>

On Wed, Dec 03, 2025 at 07:32:14PM -0800, Josh Poimboeuf wrote:
> Fix livepatch stalls which may be seen when a task is blocked with BPF
> JIT on its kernel stack.
> 
> Changes since v1 (https://lore.kernel.org/cover.1764699074.git.jpoimboe@kernel.org):
> - fix NULL ptr deref in __arch_prepare_bpf_trampoline()
> 
> Josh Poimboeuf (2):
>   bpf: Add bpf_has_frame_pointer()
>   x86/unwind/orc: Support reliable unwinding through BPF stack frames
> 

tried with bpftrace and it seems to go over bpf_prog properly
in this case:

        bpf_prog_2beb79c650d605dd_fentry_bpf_testmod_bpf_kfunc_common_test_1+320
        bpf_trampoline_354334973728+60
        bpf_kfunc_common_test+9
        bpf_prog_f837cdd29a0519b9_test1+25
        trace_call_bpf+345
        kprobe_perf_func+76
        aggr_pre_handler+72
        kprobe_ftrace_handler+361
        drm_core_init+202
        bpf_fentry_test1+9
        bpf_prog_test_run_tracing+357
        __sys_bpf+2263
        __x64_sys_bpf+33
        do_syscall_64+134
        entry_SYSCALL_64_after_hwframe+118

Reviewed-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

