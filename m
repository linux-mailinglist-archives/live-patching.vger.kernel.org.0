Return-Path: <live-patching+bounces-959-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BAB3A030D6
	for <lists+live-patching@lfdr.de>; Mon,  6 Jan 2025 20:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A58B47A1595
	for <lists+live-patching@lfdr.de>; Mon,  6 Jan 2025 19:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3970F1DF270;
	Mon,  6 Jan 2025 19:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PGZAwgVp"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85911DFDB1
	for <live-patching@vger.kernel.org>; Mon,  6 Jan 2025 19:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736192707; cv=none; b=kwvKOtR8WstYg42dYXGtsPe/FoOTUxbJaagYuJ77QjPQJUNK2NhGR8pODJErnLXl5qAElISt9DKg87rHSljVkSQ+gcB9NXM0Vtua19aO0oIVYlzzfIF+1wjYT7yUJOUoeqH1QzA8RW3PkfYknonq7MdrvWj1DzfA8YdnFY01Fl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736192707; c=relaxed/simple;
	bh=zQ3dDNxwAVqmUONVZQGHhMKpUxfHfRjY40yicSGUeAQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=uq4MiASenpT9+NI1xOrA2woZFs/pYTPZj+TwF8BouQtN5tiR/BqEgL5wRnaC+RqygvUrsxXQsMiUazhaLzYj9KBaGc0T6Uo8x8UxVcykqgAREUTiPqMW3VbAHD4x58pRFFuE0sDp3oimzNewQw8EysXCkgUd21R9/PCKMaNOA2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PGZAwgVp; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-436341f575fso152668805e9.1
        for <live-patching@vger.kernel.org>; Mon, 06 Jan 2025 11:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736192703; x=1736797503; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0aLwuHOfqts1r2RamlRiGd6YK3rscuDAhXgMPSkYQ/I=;
        b=PGZAwgVpjBrPdePP4Qwn3cWInbRollvCxbhGAXxX9UZ8jYwvfY07tNGb2PDMd1EeSg
         8D6Ohen3Ej7OrSJsU+nqkVaEnjToaDr3WZR3x+0xFF5lYWcMHyG1RD99yJpoV465Eb0W
         rc8fsNmKXOPjYds8I2NvRmvScNs1q4qO90ahjmytjMK/uwlalRv+UdIKzFbDf26xhqDD
         xp+sq9/k7lg2ZZrRleQGJGAspQXpXgBYryEfI6Gk7eDURvWTgYXlUSeD7MSbQQCuV1WV
         tS/T7oMXkbesInyGv62VqmhT2bFdg3dJh4+Jm8m+zB7PD0UcmDICYrOW2nPwOtUWWFYM
         5H/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736192703; x=1736797503;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0aLwuHOfqts1r2RamlRiGd6YK3rscuDAhXgMPSkYQ/I=;
        b=beDf1torKkCCdj1ykByneUyGX9ieufOsj5PlVTK4OojmdF9IsuH9zp2CKpwi+7cXQW
         l7wUDFoG1IKMnyumEvoT5oMYa428heiR7K1cCdnVZQE3fk9tI8T6UkCEseVLBJlDpRtj
         E4b6K0VccUtOXafQVQ7depXIQxEtPR+YgLVA60MCt3ulWIPLscfpQr/WOR2oq0bRY275
         tXtxeN1PyBJeFNvDpdxATmVjTpxUnfqLrf1oBczxH6biWqka2pUZCXnbEGf5RSKixNWl
         x+RYAaVxB9/cV9VlsGFMAyxifvjUAjWGNbEV1cikNkBxydSay1Qwj6kN59I5bNpt9PPN
         Y/XA==
X-Forwarded-Encrypted: i=1; AJvYcCX/ip1mXz3zC1uWVY8Zxq9d2UhAdev9OxcbLoqzR86ly/3Wvg6rXM9/66TPiAwlmsyiIjk7oUsWL+fFDVCY@vger.kernel.org
X-Gm-Message-State: AOJu0YzVGtSMift2RK/gtH0Yl+oW+sUCI5RSN5CE9lgVmu3M1wqI3FKE
	lqN3QzSsdaykNpNGJX/QFl7M9jYOYOpgyIPzLMwIgXZEp+Td/KNlr4wOEkdjZOI=
X-Gm-Gg: ASbGncvuZovD+Be9SQnVC46u/rHlexFBW88VCY474v7lsMlWVI0tH7lwSy37++Gp+V8
	CpLhF6YgCmxRQx/JTdz7RaDfoKaa4YvYovY3Mra8p1KtXM0w0ks3dCVNUfjmoGOmrrx9eOwDhu/
	+lXaxVisfWTv+9twRrFsFmfqFFBVV9ARcithL1f0vrA6Pfp1ZgF3Q5QJn4Jmj8le4tW+8sHXiXU
	GI8ghCwbrF9m3N74FvOUicyOt0p6ysTiSOqBOnKszr+2ANBr3K6bp4xBhom
X-Google-Smtp-Source: AGHT+IH2BY0sTS8enQiAP1KtexhKyJ6/pVUM0cYmW/vvBj8QsCYf2kLQBIcE4NYHTcKNybVDe0O0QA==
X-Received: by 2002:a05:600c:3b13:b0:436:488f:4f5 with SMTP id 5b1f17b1804b1-4366864420bmr511100335e9.19.1736192702985;
        Mon, 06 Jan 2025 11:45:02 -0800 (PST)
Received: from [10.100.51.161] ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b013a1sm614843995e9.11.2025.01.06.11.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 11:45:02 -0800 (PST)
Message-ID: <0530eee7-f329-4786-bea3-c9c66d5f0bed@suse.com>
Date: Mon, 6 Jan 2025 20:45:01 +0100
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ROX allocations broke livepatch for modules since 6.13-rc1
From: Petr Pavlu <petr.pavlu@suse.com>
To: rppt@kernel.org, akpm@linux-foundation.org
Cc: =?UTF-8?Q?Marek_Ma=C5=9Blanka?= <mmaslanka@google.com>,
 mcgrof@kernel.org, regressions@lists.linux.dev,
 linux-modules@vger.kernel.org, linux-mm@kvack.org,
 live-patching@vger.kernel.org, joe.lawrence@redhat.com, jpoimboe@kernel.org,
 pmladek@suse.com
References: <CAGcaFA2hdThQV6mjD_1_U+GNHThv84+MQvMWLgEuX+LVbAyDxg@mail.gmail.com>
 <c37395e2-1ab5-4175-9920-5144cf60e25e@suse.com>
Content-Language: en-US
In-Reply-To: <c37395e2-1ab5-4175-9920-5144cf60e25e@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/5/25 15:51, Petr Pavlu wrote:
> On 12/30/24 01:09, Marek Maślanka wrote:
>> Hi Mike and others,
>>
>> I discovered that the patch "[v7,4/8] module: prepare to handle ROX allocations
>> for text" has disrupted livepatch functionality. Specifically, this occurs when
>> livepatch is prepared to patch a kernel module and when the livepatch module
>> contains a "special" relocation section named
>> ".klp.rela.<MODULE_NAME>.<SECTION_NAME>" to access local symbols.
> 
> Thank you for the report. It is possible for me to reproduce the issue
> on my system. An annoying part is to create the
> .klp.rela.<objname>.<secname> data, for which I eventually used one
> floating variant of klp-convert [1]. To hit the problem, <objname> must
> point to an object that is different from vmlinux. Such relocations are
> processed by the livepatch code later than regular module relocations,
> as you pointed out after mod->rw_copy is already reset.
> 
> I think the bug should be addressed in principle by Mike's recently
> posted rework of the feature [2] but unfortunately, its current version
> makes my system also unbootable [3].

A simpler fix could be:

diff --git a/include/linux/module.h b/include/linux/module.h
index 94acbacdcdf1..b3a643435357 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -773,7 +773,8 @@ void *__module_writable_address(struct module *mod, void *loc);
 
 static inline void *module_writable_address(struct module *mod, void *loc)
 {
-	if (!IS_ENABLED(CONFIG_ARCH_HAS_EXECMEM_ROX) || !mod)
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_EXECMEM_ROX) || !mod ||
+	    mod->state != MODULE_STATE_UNFORMED)
 		return loc;
 	return __module_writable_address(mod, loc);
 }

Hm, is it expected that Mike's rework to drop rw_copy will make it into
6.13 or should I properly post this minimal fix for review?

-- 
Thanks,
Petr

