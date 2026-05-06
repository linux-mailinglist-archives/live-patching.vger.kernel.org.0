Return-Path: <live-patching+bounces-2738-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GM3qKoYz+2nfXgMAu9opvQ
	(envelope-from <live-patching+bounces-2738-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 06 May 2026 14:26:46 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B31634DA2AE
	for <lists+live-patching@lfdr.de>; Wed, 06 May 2026 14:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1988F300D4DF
	for <lists+live-patching@lfdr.de>; Wed,  6 May 2026 12:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E74E44A71D;
	Wed,  6 May 2026 12:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C3as7VWl"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD1731A7E4
	for <live-patching@vger.kernel.org>; Wed,  6 May 2026 12:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778070400; cv=none; b=mW4CEHKz4j5gbT37N/N9mQo8BFSpPKTOjH17IAz+sAkvxNpxQ6MV/5oKjjRqJykGNzHRi/qy4ZmtmhPO5vO4dao/t+W4qRPRyJc51YYU4Pc+P/iE/MVwDPw7rr06okCVMvonhE4RpMk27mqbJXSKw+6t/lMSKK8Ir6e4MPQlPD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778070400; c=relaxed/simple;
	bh=BcXorbEfsFAx6QbQO57Jq1tR7UjL6pcjEAnnjG+0zeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwwQ9oFO/kRGoUFARRbY9FjoVA9hWk70OfkO+2COhBiQqO3P1gNKRjgJsVWYkDnXPVr/H2v0ddiF/pWLN/2gdyRHf2XSjpNYkuxuFKOZ4S3g/Aa2ReJCYaJ5KPLShRdVbgN8bHxDo8x6RtNWB7ze4/mmz2BkJqQ/It8EsOEfpj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C3as7VWl; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-44a786a9a35so3533673f8f.3
        for <live-patching@vger.kernel.org>; Wed, 06 May 2026 05:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778070396; x=1778675196; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZMpHPIoDyk7lQF2tr26c7noerDTVIrKkAUCsthGLLgs=;
        b=C3as7VWlBk+FyhT8KrKijDUU2JWE4VzczrgG1KllX2i4NIB5E6BgG8VdnYDbP3icpl
         7pWVuczN6ryiy57YmVn3J39qzLxyK+mO8OEWoPfLN7oUUAroudMb1iSfUNDM/F7k1MGz
         hHa9ioYD2TN9vo/SdsjZ3goZDyQo0ikZ92nTxKXus6g6+lCKsxLCahT1+RwTnVC4mMhx
         LahgoPqOCLg1htaSxGJgKZSHeS2AFYuPYuaY0YtAK/ocMcQnKRTksoBSpTW7YvefRN59
         COaOBhCaSALND8mnxDVcMPTONBK0NRaT3mdy45BZWTJZeIpWviOMV8j8v03c+L2wUWyT
         l58A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778070396; x=1778675196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZMpHPIoDyk7lQF2tr26c7noerDTVIrKkAUCsthGLLgs=;
        b=M+gkQywksOwMln7ld1i44gBxkVmiO9Jrv60KCuC+JE6j7uGTkCe2eGdb3qj0aF2lPC
         lVMpqVleXSB54eXVpG+JntNb0eOvAwmLh27EONwXj83yz0pbWPNkkwFjk4G8R7tflAGV
         hLhm5yzbJkyMzX6gjLBrdYx/EKqoRpuvZVWObajYakxZUHgUBPxfxQvyUcCrL1DNW4RI
         n+7RIeE538njRtqAxyB9bCHc9AlwSFLjZKPe5gB0qjfGdkLspUscDX2mHjzC+eBLmNXj
         IqTmwPLlP+5VYg4s/5+CKLEa3LPxgORnhdiitptFKTUX2zeWg0ic5qkSp6CBFWsotx6r
         vEEw==
X-Forwarded-Encrypted: i=1; AFNElJ8GzXe3LfLb7uH5KPODrwKmb0ID0aL4WciJFPi6S+/6WX21sEMb/kb9Lp90Z6Vh8z2ZMS9Im00uwKSz1Q1B@vger.kernel.org
X-Gm-Message-State: AOJu0YxpwmsmOzLoGh+3tgaoMPb3SHpaNHMq8yxBYl/AdDbnBLzcfQmU
	fawwT3Bz4kUsAlT5bP4Gp9EHWN8EyVguJGbe4xFT2tgXTGqLtvHNEXMsc7UFOmXE9qU=
X-Gm-Gg: AeBDiesEIXO6gymGGukOTFBpQ+SdpirzO5o1TP2FS+dwYhOQCrXRPLJtRJOby/u/WKp
	mR/msYZLIi2bGn34SdMXA0qW4sOXVfMZmjIrDJUf76saxHdnJb7rnXVoyxMY30wVvDcEoYJG15N
	EhajOsSW3UPmP+H23NQVC7Fo6UfHqlivGVtLehcejpsD0lxh0H0G3TwBYK+8MlIu0CIbg6FvDbU
	XkWLJJ7iiUyW2Gmrr767oQvbrlVfzCbThUrfvznLf+7NgfhDIOpVMiPwsp1hyMIO4hffxLS1kbq
	nvvmaVgdl2KtfHZ4h2VYukpGbI5g0bkGrDxaezvQlGGlI/dGnX6F8OJAot/4RvWdZoEmJHxcHdl
	6fb3QOX5U3+/ku0zYe3JVFwXqlQzZYiyUlj+znlcXtXsLo8pVeSEV4T1xqE6Aug3E7oeZk7BGI0
	WIwWYRQF0TCznUhbw10tpsbnFvwSlcpgAyBGru
X-Received: by 2002:a05:6000:280c:b0:451:6760:fc2d with SMTP id ffacd0b85a97d-4516760fc6bmr3489346f8f.0.1778070395548;
        Wed, 06 May 2026 05:26:35 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45052a488d8sm12077299f8f.12.2026.05.06.05.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 05:26:35 -0700 (PDT)
Date: Wed, 6 May 2026 14:26:32 +0200
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	marcos@mpdesouza.com
Subject: Re: [PATCH v5 0/6] kselftests: livepatch: Adapt tests to be executed
 on 4.12 kernels
Message-ID: <afszeCkeSBvn_ePB@pathway.suse.cz>
References: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
X-Rspamd-Queue-Id: B31634DA2AE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2738-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,pathway.suse.cz:mid]

On Mon 2026-05-04 15:34:41, Marcos Paulo de Souza wrote:
> This is the fifth version of the patchset, which fixes the last Sashiko
> comment, about overwriting MOD_LIVEPATCH global variable and using a
> local variable to avoid module load clashing when an older kernel
> don't support some sysfs attributes.
> 
> Original cover-letter:
> These patches don't really change how the patches are run, just skip
> some tests on kernels that don't support a feature (like kprobe and
> livepatched living together) or when a livepatch sysfs attribute is
> missing.
> 
> These patches are based on printk/for-next branch.
> 
> Please review! Thanks!
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
> Changes in v5:
> - Edit the last three patches to avoid overwriting MOD_LIVEPATCH
>   variable, using a local variable. This fixed the last Sashiko report.
> - Link to v4: https://patch.msgid.link/20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com

JFYI, the patchset has been pushed into livepatch.git,
branch for-7.2-selftests.

Best Regards,
Petr

