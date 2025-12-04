Return-Path: <live-patching+bounces-1897-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AE513CA3F1B
	for <lists+live-patching@lfdr.de>; Thu, 04 Dec 2025 15:09:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A0E43033DE9
	for <lists+live-patching@lfdr.de>; Thu,  4 Dec 2025 14:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6353A2EA73D;
	Thu,  4 Dec 2025 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ML1KVpCz"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8103E225760
	for <live-patching@vger.kernel.org>; Thu,  4 Dec 2025 14:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764857070; cv=none; b=N12MGnlAWKd2Fe3xDzW8ubTQfYWfWkBPk0cMRR4ruHxzUT129k2YMHh9U0LzYTjOou2lFcBydjLp2g09s9YjIXnvypiYPiCGwVLAdPh4t3LQhaUB1Bw0YdpsP28Ra6xxbx/Aw6y2lWx8f1itb3YviyzGEhnzog8P/fjdj5SkA88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764857070; c=relaxed/simple;
	bh=aRzuM73KIbESyhohodxcT54k6Qy1Jg+q5i0vbxCsmNc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hLxJmfvW+zxzxyigOAlvPhG4XlRV10UZvMg/Wwu1NUgLVk/hbLiCTUnxUT5JqKRMv2XpXgeHijrga1EsU7XWXXii/gKiuGm8ACdKY/lPQlCa2aZFbttVNmSCuE6+ZsLbjInXpSrJ9UFzAS+2OpTKWapTMJI8bZZK1U22mMwHGiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ML1KVpCz; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-477aa218f20so7276905e9.0
        for <live-patching@vger.kernel.org>; Thu, 04 Dec 2025 06:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857066; x=1765461866; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ulveplzjG/cdWPrBGoBC49yQV2WnDro7d1WFbRqxSbE=;
        b=ML1KVpCz5g49x/su4FObrGbMPrGPFc3juLG93l/iB1GQxfeHn22EteBTS/G8itL6Ns
         hfYS2r6GWMFzOblIlM1D3RWYgTZ+uwVapAQWlkc07yErDeLUNFGDvdyH+0KwN02/nhr/
         sf0T1jUJzvJ4eG48fG//3cI/1eJOCqQlXnE7QVedi9SW5OY1A3viCUGxC8mRHIKx9zut
         3STOogJv+RWlJ1EQ/Q6wEVFYAKuyNovMW3KSGYGL6mu4IvNs+bGMefnEniUVqYGQllI7
         SPAdf3Slt/8c0jLDZSwHxIr7KPPPIOQ3QYz3S5xOgT+gbgLGgRBRx6PCvBvrQfWUnOxZ
         lEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857066; x=1765461866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ulveplzjG/cdWPrBGoBC49yQV2WnDro7d1WFbRqxSbE=;
        b=w3zjPsNgLBJXcW024hQtaWUs2JTdR6rau1jczKkafRCCWCRzejXy/PBtqEwdhgfjyQ
         awp4csN/sj/cKbf+4BB+uASxLbAIQEPlFd/zR2u3T6FxSSaC07cS2M0US2JXAyF1EDhK
         CLY+nPrNkGt0j7mviEiHaTV9M+DdoHysqPomllCR/cYKpuE7T3qydAblpZlfilwZ6rts
         JhvmQjwRRv0bauFLTDpZ9yHD5HdOgY66pp4esqUMhN1VUUUxr92Kiti4oQ0Ce+4sZB32
         3Fm6h1GG7PEXiUuSxn7nx4Etp72XzOpTIIcFVw02bN2+gungY7+ph2dYro7VdpiGDBNA
         URgA==
X-Forwarded-Encrypted: i=1; AJvYcCVQWI0fw0LDHx/ZZ0REdWyjMT388i/jBhxjPSOseNFW6lkgRRkq08pS5i74sn7MG95rIslmrhPq84jwnXCU@vger.kernel.org
X-Gm-Message-State: AOJu0YwHjesavmcdrOvvlp39g/XkiiMb+xChE2Je1krHlD7cHMPnopk4
	o+IrEefEFfiK+ZnNse488Q7PPumbb1q6ITeS85aBm3soLl4caoUrBs5a
X-Gm-Gg: ASbGnctGu4e03kHyNknCwzLjiMoCcr9OhGVOo1cjeLPys+hnMF5HZG8zPqA8IlG6vl3
	gYwaSz++FJAFSQZu4VIiHIoLyUq36q4oEhnJzy54lAaQOgIyEMoDPymV/AB4YHm00HRoE9DBc6j
	JhLlt1N1JhvK0C33JPpockv6wAy9uxq4h4tgiICpRX3XPYRZ/qxue9ROSmn2hRm4Yk5y1gSz6K4
	YtlZvFyBURy+90iWidWpiFxmno/jUot/sQjedxojk8avrfNn4aH8ILnO40gxroCpCrtCe4gJerE
	hEKMUGT0mfHqzrXtKgRQl8oviLJgvRhxt8t8XFcqZ0jdLRRWGGt84WSxbnwfn5wTDiVJRZ9QOOx
	6Q2sBrxyxV3ZhThh2iYhDj18+3z/Ul9yZDzo1lHe58DWk7adqNYdr2VH46yId
X-Google-Smtp-Source: AGHT+IEUXKkr+j8AS7GtCx+h4kXKs7W2C+wgWRquG6wCDe6i84w2IfLLYiJHEkhLXTOaZv+w+fBsjw==
X-Received: by 2002:a05:600c:3152:b0:477:6d96:b3c8 with SMTP id 5b1f17b1804b1-4792af3d888mr59493485e9.23.1764857065548;
        Thu, 04 Dec 2025 06:04:25 -0800 (PST)
Received: from krava ([2a02:8308:a00c:e200::b44f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d331e62sm3508498f8f.35.2025.12.04.06.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:04:25 -0800 (PST)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Thu, 4 Dec 2025 15:04:23 +0100
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
Subject: Re: [PATCH v2 1/2] bpf: Add bpf_has_frame_pointer()
Message-ID: <aTGU5zRKWWU78mCS@krava>
References: <cover.1764818927.git.jpoimboe@kernel.org>
 <fd2bc5b4e261a680774b28f6100509fd5ebad2f0.1764818927.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd2bc5b4e261a680774b28f6100509fd5ebad2f0.1764818927.git.jpoimboe@kernel.org>

On Wed, Dec 03, 2025 at 07:32:15PM -0800, Josh Poimboeuf wrote:
> Introduce a bpf_has_frame_pointer() helper that unwinders can call to
> determine whether a given instruction pointer is within the valid frame
> pointer region of a BPF JIT program or trampoline (i.e., after the
> prologue, before the epilogue).
> 
> This will enable livepatch (with the ORC unwinder) to reliably unwind
> through BPF JIT frames.
> 
> Acked-by: Song Liu <song@kernel.org>
> Acked-and-tested-by: Andrey Grodzovsky<andrey.grodzovsky@crowdstrike.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  arch/x86/net/bpf_jit_comp.c | 12 ++++++++++++
>  include/linux/bpf.h         |  3 +++
>  kernel/bpf/core.c           | 16 ++++++++++++++++
>  3 files changed, 31 insertions(+)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index de5083cb1d37..3ec4fa94086a 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1661,6 +1661,9 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image, u8 *rw_image
>  	emit_prologue(&prog, image, stack_depth,
>  		      bpf_prog_was_classic(bpf_prog), tail_call_reachable,
>  		      bpf_is_subprog(bpf_prog), bpf_prog->aux->exception_cb);
> +
> +	bpf_prog->aux->ksym.fp_start = prog - temp;
> +
>  	/* Exception callback will clobber callee regs for its own use, and
>  	 * restore the original callee regs from main prog's stack frame.
>  	 */
> @@ -2716,6 +2719,8 @@ st:			if (is_imm8(insn->off))
>  					pop_r12(&prog);
>  			}
>  			EMIT1(0xC9);         /* leave */
> +			bpf_prog->aux->ksym.fp_end = prog - temp;
> +
>  			emit_return(&prog, image + addrs[i - 1] + (prog - temp));
>  			break;
>  
> @@ -3299,6 +3304,9 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
>  	}
>  	EMIT1(0x55);		 /* push rbp */
>  	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
> +	if (im)
> +		im->ksym.fp_start = prog - (u8 *)rw_image;
> +
>  	if (!is_imm8(stack_size)) {
>  		/* sub rsp, stack_size */
>  		EMIT3_off32(0x48, 0x81, 0xEC, stack_size);
> @@ -3436,7 +3444,11 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
>  		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
>  
>  	emit_ldx(&prog, BPF_DW, BPF_REG_6, BPF_REG_FP, -rbx_off);
> +
>  	EMIT1(0xC9); /* leave */
> +	if (im)
> +		im->ksym.fp_end = prog - (u8 *)rw_image;

is the null check needed? there are other places in the function that
use 'im' without that

thanks,
jirka


> +
>  	if (flags & BPF_TRAMP_F_SKIP_FRAME) {
>  		/* skip our return address and return to parent */
>  		EMIT4(0x48, 0x83, 0xC4, 8); /* add rsp, 8 */
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index d808253f2e94..e3f56e8443da 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1257,6 +1257,8 @@ struct bpf_ksym {
>  	struct list_head	 lnode;
>  	struct latch_tree_node	 tnode;
>  	bool			 prog;
> +	u32			 fp_start;
> +	u32			 fp_end;
>  };
>  
>  enum bpf_tramp_prog_type {
> @@ -1483,6 +1485,7 @@ void bpf_image_ksym_add(struct bpf_ksym *ksym);
>  void bpf_image_ksym_del(struct bpf_ksym *ksym);
>  void bpf_ksym_add(struct bpf_ksym *ksym);
>  void bpf_ksym_del(struct bpf_ksym *ksym);
> +bool bpf_has_frame_pointer(unsigned long ip);
>  int bpf_jit_charge_modmem(u32 size);
>  void bpf_jit_uncharge_modmem(u32 size);
>  bool bpf_prog_has_trampoline(const struct bpf_prog *prog);
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index d595fe512498..7cd8382d1152 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -760,6 +760,22 @@ struct bpf_prog *bpf_prog_ksym_find(unsigned long addr)
>  	       NULL;
>  }
>  
> +bool bpf_has_frame_pointer(unsigned long ip)
> +{
> +	struct bpf_ksym *ksym;
> +	unsigned long offset;
> +
> +	guard(rcu)();
> +
> +	ksym = bpf_ksym_find(ip);
> +	if (!ksym || !ksym->fp_start || !ksym->fp_end)
> +		return false;
> +
> +	offset = ip - ksym->start;
> +
> +	return offset >= ksym->fp_start && offset < ksym->fp_end;
> +}
> +
>  const struct exception_table_entry *search_bpf_extables(unsigned long addr)
>  {
>  	const struct exception_table_entry *e = NULL;
> -- 
> 2.51.1
> 
> 

