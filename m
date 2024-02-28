Return-Path: <live-patching+bounces-198-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F031A86A449
	for <lists+live-patching@lfdr.de>; Wed, 28 Feb 2024 01:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F2B2289A70
	for <lists+live-patching@lfdr.de>; Wed, 28 Feb 2024 00:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A151364;
	Wed, 28 Feb 2024 00:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2Gb4ltS"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB682366
	for <live-patching@vger.kernel.org>; Wed, 28 Feb 2024 00:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709079021; cv=none; b=Z3o8N1T5HAT1S3pD5x7UZwXJIIR1UwrRnmVDpiOA3VaHT3OqDWUZgOzeHKcH2Cv3iVVpyPRvS9/JWOqviEYZYFaXZPEN8SZbSEItvLSNsoruL82B4T6lUx2rPV6zY+XWouoLBZWzC0uer7Bv73u971uawHTNDTgbo2OD4Lqo2LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709079021; c=relaxed/simple;
	bh=7Bibe+mApP2qw+Bwb89kIz1Vorq4HcJl2XyOfxCc+rI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EQBm3hg+4Hiqlh18IEsBzZAfgZYUK4MVt67/aVEOgYu2LFnbS0liTAr/MUsFirjb/Kz473XDLTZ3XW+hbTyddEURMZH55R6pS7Q2xCEaYXQnbbR7HdsRhekOB58ND+8MDd4uOrxe+fUAOkghZhj16eVvbc0bqXlnwjaQX2j0mQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2Gb4ltS; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so46904139f.0
        for <live-patching@vger.kernel.org>; Tue, 27 Feb 2024 16:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709079019; x=1709683819; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3uNCkE/Y4bucRwr/vs7c1ruuOADEG13u7lr08BZ4VNA=;
        b=D2Gb4ltSZBbw7GNcjBZZWXuvkDuJasDEjNQU6jiVVhbDbapAbLVi1ryZZx7vIM+Zhw
         DBaNdui24vVhN05VovPFFOC3VWlaiuW37K4tgOhoAFGc/2tHOoiisBmZk6rGFd2AYnrY
         7NlS96wYAGJd51AiEkVGeOB1wGejgP6BoGtfA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709079019; x=1709683819;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3uNCkE/Y4bucRwr/vs7c1ruuOADEG13u7lr08BZ4VNA=;
        b=cPgj3GS6FGpQqB+2Y4kfU+8i+XdauCe4T0/DQrsU1I59Xk1HQ8HLSRItg0E4Sfiuan
         Ns7AnJa3AREBqLHciGkyLXkQuALH3u9twta0C49nc5roy48SDONc58MuwqVVn4J97Ayq
         HVtRQ35QZgNAAOwHk1rSJT0jF1jRmv6K/qTZUR/BOn03y62hey83jrLXXM5kMYIgYo4C
         Ngiz8cxiJ+r5TIv5lN6wl9ckuYvIL/36mTZZ9i8By1JNYmMQDUY5FmT/lyrwz1AqxhCc
         rawvKduN0ii5ubMCqoyHAclmhb3yi1C9d7WKhgIK6AmrSBONye46xkwyJaV6WzgGXzn/
         Ye3g==
X-Forwarded-Encrypted: i=1; AJvYcCVID7mwLfOnk8JLAPJye/eo82jU1QtfOgkFz+9QIsO/bOKpDkH8ci4Fj57FkFP5vHBFN9Jb6wj67kfseXDa0Io+XtwP5GllyAPINDyYoA==
X-Gm-Message-State: AOJu0YwHkCamD7xwGecO7uZeAupBH2QhOZu6yifN4LK+PtdsMwxhGxi8
	mMlVP8h71Qr+dj68+qFzzDGJMgztum23CsB+59kgeHuT0k1z42rYdpbtrQzR42c=
X-Google-Smtp-Source: AGHT+IGrxhuv2/vozEcMAJsAG2BL6qpv5diYWB6ZxOntrxwP6jDQRasA2qEhpJhFBGgL0WngloEcfg==
X-Received: by 2002:a05:6e02:20e4:b0:365:1967:e665 with SMTP id q4-20020a056e0220e400b003651967e665mr11415974ilv.2.1709079018924;
        Tue, 27 Feb 2024 16:10:18 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id x14-20020a056e020f0e00b00364b66eb5e3sm2427560ilj.24.2024.02.27.16.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 16:10:18 -0800 (PST)
Message-ID: <76d006e1-aeb1-4622-aa9e-6bf4101a4e15@linuxfoundation.org>
Date: Tue, 27 Feb 2024 17:10:18 -0700
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] Improvements to livepatch kselftests on top of
 kselftest-next
Content-Language: en-US
To: Marcos Paulo de Souza <mpdesouza@suse.com>, Shuah Khan
 <shuah@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, kernel test robot <lkp@intel.com>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240221-lp-selftests-fixes-v2-0-a19be1e029a7@suse.com>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240221-lp-selftests-fixes-v2-0-a19be1e029a7@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 10:17, Marcos Paulo de Souza wrote:
> The changes on lib.mk are both for simplification and also
> clarification, like in the case of not handling TEST_GEN_MODS_DIR
> directly. There is a new patch to solve one issue reported by build bot.
> 
> These changes apply on top of the current kselftest-next branch. Please
> review!
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
> Changes in v2:
> - Added a new patch to avoid building the modules/running the tests if
>    kernel-devel is not installed. Resolving an issue reported by the
>    build bot.
> - Reordered the patches, showing the more simple ones first. Besides
>    patch 0002, all the other three didn't changed since v1.
> - Link to v1: https://lore.kernel.org/r/20240215-lp-selftests-fixes-v1-0-89f4a6f5cddc@suse.com
> 
> ---
> Marcos Paulo de Souza (4):
>        selftests: livepatch: Add initial .gitignore
>        selftests: livepatch: Avoid running the tests if kernel-devel is missing
>        selftests: lib.mk: Do not process TEST_GEN_MODS_DIR
>        selftests: lib.mk: Simplify TEST_GEN_MODS_DIR handling
> 
>   tools/testing/selftests/lib.mk                        | 19 +++++++------------
>   tools/testing/selftests/livepatch/.gitignore          |  1 +
>   tools/testing/selftests/livepatch/functions.sh        | 13 +++++++++++++
>   .../testing/selftests/livepatch/test_modules/Makefile |  6 ++++++
>   4 files changed, 27 insertions(+), 12 deletions(-)
> ---
> base-commit: 6f1a214d446b2f2f9c8c4b96755a8f0316ba4436
> change-id: 20240215-lp-selftests-fixes-7d4bab3c0712
> 
> Best regards,

Applied all except the last patch to linux-kelftest next for Linux 6.9-rc1

thanks,
-- Shuah


