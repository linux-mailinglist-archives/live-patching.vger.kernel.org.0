Return-Path: <live-patching+bounces-1473-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC307AC6C0E
	for <lists+live-patching@lfdr.de>; Wed, 28 May 2025 16:45:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7943C17CB73
	for <lists+live-patching@lfdr.de>; Wed, 28 May 2025 14:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49141BC9F4;
	Wed, 28 May 2025 14:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HI6pUFuM"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419F72AD31
	for <live-patching@vger.kernel.org>; Wed, 28 May 2025 14:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748443529; cv=none; b=DFJQoz0XdpGHFuFOJY2sl9eDjRkChI6VpDOaKiackdoP4fM2xu5AlGJa/U19QVF0wlzkUX0rYPsGCHmwYpy2c6WFL6Za0O6AeVwkTh8TLb55lA0To9zr7jjxlgFJoxaXoU5DfUFK9tT7hZB8VUFJykj9Kaeib7VHq3BbdSf38sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748443529; c=relaxed/simple;
	bh=pmJnWyaWtacG4qA9MnSrkri+m0ZViEInoNhsLA5VOO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ESH7kcVyWYKnL4VrY+n9p9v8wuAWEd8/AiY0W9URtWr6RklDl4MdRynlC37ha/rJSyPZ5e3n2OKfyufu1ctLK4EIQjPOaNIYSigbl/WnxnLMQQWTdK3E8c0YGgjkTcCbngSdHb+IK0y5dMh/V528Es10AUlBNQsoA8JLdeuLNdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HI6pUFuM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748443527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8NsMEdT9aL0A0o+tflXH9VCdZUeVOkrNj4UYHGNir0U=;
	b=HI6pUFuM+jKPLUR6IlTJ7TOlx2d1jJUoIeNVwCI+sCYO056Fu9ZxkPtQhwJHqC5PCF0gzD
	T8MGsaGitOHHVjaV7I9wKfQW2aYtCdI5rt5J3HWYp2VzVAhWQm3jdyaCYoygqQlY3tVkSw
	wAQgA5jYoJqHmZHGZR/K1JiFld2b/fI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-adKFlnONMG26jsoArzeMjw-1; Wed, 28 May 2025 10:45:25 -0400
X-MC-Unique: adKFlnONMG26jsoArzeMjw-1
X-Mimecast-MFC-AGG-ID: adKFlnONMG26jsoArzeMjw_1748443525
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6fab979413fso26719096d6.2
        for <live-patching@vger.kernel.org>; Wed, 28 May 2025 07:45:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748443525; x=1749048325;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8NsMEdT9aL0A0o+tflXH9VCdZUeVOkrNj4UYHGNir0U=;
        b=wE1mz0si3tRwW1BUFKH9DkDTFnzPPXC6d8en8puikENwaZjHIc1Tpwdz0Md8GD9doq
         rc770MeTlXZz6puiG3fliiE2RysSgGw7ZBWUK5r+8waSbhY6+Q0d6IQ+I+ZySLZ0jmv3
         fn+cON4EtMZGlcxJ8Vav6MtrqSmRAumXwYxpVmshwX2xT/VVf9KTN3iJaZgMCQjaw2A0
         bGsUqcAQr4NTmG2Z9i9trogotAEea2DmFJk4oUMu06gfrkfo4WhLLMeHQRIgzV/Un1Mc
         Kuc+hl+mI5cfCpp44jB465zqYNxqUlvGHUI36DsqZVPODy2I4n2y38+15yFQFSB8EQ+4
         2YNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPMUPu8t8WZn7hqMtriC0S5w3ZQqLx1/VwLMPEW3BDXmydXkhIaQqqZPX56aDhTLsc704plYew1TTjX+OC@vger.kernel.org
X-Gm-Message-State: AOJu0YwnxSjK5aqQw3RXvuo2LfMY9wxzegXGMDw0j23bp7XvTAvDv/k2
	9ytWygC4i8p8t6lofyWWID/xoUen2ZKFojw5rX51/70oKeMrrXR7qSPJn8VQtHYudvgjdRxDcBD
	pVWJ+UrRTKt4SPQy/SuIr27cmc6uZD8D37DsCT7fuRk1LoE8ED/a59nyEvybWSrucyxo=
X-Gm-Gg: ASbGnctRlVctLYFeTxR18nhyQgp2yOVhmgkgnC8v8aQRiOouSM2oiSM/Nfz1+MC+mFa
	xduaInIOyYwiHAkUr0q+pFInT8x01WUl/us6hjcej21GdkDd3yIcB+JdKF43pZHNfU52DAT8JZD
	UP6mzeGuPpJsYJ+T7BgrSRj9PLbFpOKjHMrIgoGGnDC0SlBss407AVgWu4F+RwZkRC9hjbtmKGm
	JsJfVkOs+s6Ard+Jk2D9ididGdaWZell144izRbOjkPxU9kZ4f+C+vByrJFa+rcJpCvF9OceqRH
	6nYiW0tLAmQoS6QkfW5+mwUzghg3vX4mC5KlSiEtEcy3ZTzeSGPhoa6roOGjQ6WHvOU=
X-Received: by 2002:a05:6214:20e5:b0:6fa:9b5e:f1d1 with SMTP id 6a1803df08f44-6fa9d2954d2mr264243166d6.24.1748443524824;
        Wed, 28 May 2025 07:45:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjuC/6+FGCtr2tyOGkUY41luUxvRRwiJGQ2hOzrBdgImVPVlnSyRIaLJNcGzFhoJ53ssTsYA==
X-Received: by 2002:a05:6214:20e5:b0:6fa:9b5e:f1d1 with SMTP id 6a1803df08f44-6fa9d2954d2mr264242576d6.24.1748443524365;
        Wed, 28 May 2025 07:45:24 -0700 (PDT)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fac0b22361sm7140546d6.2.2025.05.28.07.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 May 2025 07:45:23 -0700 (PDT)
Message-ID: <88a28ee7-ec83-4925-9cae-085b0dcc78fe@redhat.com>
Date: Wed, 28 May 2025 10:45:22 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 49/62] kbuild,objtool: Defer objtool validation step
 for CONFIG_LIVEPATCH
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
 Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
 Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>,
 Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>,
 Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <0a12cca631dd6f4c55015e224acefb641b3824ce.1746821544.git.jpoimboe@kernel.org>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <0a12cca631dd6f4c55015e224acefb641b3824ce.1746821544.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/9/25 4:17 PM, Josh Poimboeuf wrote:
> In preparation for the objtool klp diff subcommand, defer objtool
> validation for CONFIG_LIVEPATCH until the final pre-link archive (e.g.,
> vmlinux.o, module-foo.o) is built.  This will simplify the process of
> generating livepatch modules.
> 
> Delayed objtool is generally preferred anyway, and is already standard
> for IBT and LTO.  Eventually the per-translation-unit mode will be
> phased out.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  scripts/Makefile.lib    | 2 +-
>  scripts/link-vmlinux.sh | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index bfd55a6ad8f1..a68390ff5cd9 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -278,7 +278,7 @@ objtool-args = $(objtool-args-y)					\
>  	$(if $(delay-objtool), --link)					\
>  	$(if $(part-of-module), --module)
>  
> -delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT))
> +delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT),$(CONFIG_LIVEPATCH))
>  
>  cmd_objtool = $(if $(objtool-enabled), ; $(objtool) $(objtool-args) $@)
>  cmd_gen_objtooldep = $(if $(objtool-enabled), { echo ; echo '$@: $$(wildcard $(objtool))' ; } >> $(dot-target).cmd)
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index 51367c2bfc21..acffa3c935f2 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -60,7 +60,8 @@ vmlinux_link()
>  	# skip output file argument
>  	shift
>  
> -	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT; then
> +	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT ||
> +	   is_enabled CONFIG_LIVEPATCH; then
>  		# Use vmlinux.o instead of performing the slow LTO link again.
>  		objs=vmlinux.o
>  		libs=

At this commit, I'm getting the following linker error on ppc64le:

ld -EL -m elf64lppc -z noexecstack --no-warn-rwx-segments -pie -z notext
--build-id=sha1 -X --orphan-handling=error
--script=./arch/powerpc/kernel/vmlinux.lds -o .tmp_vmlinux1
--whole-archive vmlinux.o .vmlinux.export.o init/version-timestamp.o
--no-whole-archive --start-group --end-group .tmp_vmlinux0.kallsyms.o
arch/powerpc/tools/vmlinux.arch.o

vmlinux.o:(__ftr_alt_97+0x20): relocation truncated to fit:
R_PPC64_REL14 against `.text'+4b54
vmlinux.o:(__ftr_alt_97+0x270): relocation truncated to fit:
R_PPC64_REL14 against `.text'+173ecc

* Note: I dropped ("[PATCH v2 45/62] x86/extable: Define ELF section
entry size for exception tables") since it doesn't build as per the
comment I left on that patch.

-- 
Joe


