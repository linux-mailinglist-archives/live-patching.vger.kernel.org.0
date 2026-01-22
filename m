Return-Path: <live-patching+bounces-1917-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CPrSApDicWk+MgAAu9opvQ
	(envelope-from <live-patching+bounces-1917-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 22 Jan 2026 09:40:48 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C74C63513
	for <lists+live-patching@lfdr.de>; Thu, 22 Jan 2026 09:40:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E7D197A5136
	for <lists+live-patching@lfdr.de>; Thu, 22 Jan 2026 08:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC983D2FED;
	Thu, 22 Jan 2026 08:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aavlEQUN"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5008934DB74
	for <live-patching@vger.kernel.org>; Thu, 22 Jan 2026 08:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769070866; cv=none; b=JvL596HjB6I+qlz9zHdkPbAo0KcO/HieM2FZAxPjsCmOSBlPMzc+fA79x/F6jyCHQ4INpGSy98ZJJFBKNkZC4MU3nro3AiN29yDFlHd9+chE442CDQZpFmR9TRw3amuBplNJt2HzTXUhSWJMnFoOgsnoa4yPu+MeEn/1o/SdqCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769070866; c=relaxed/simple;
	bh=HDmT7452O0N3cmGqBBG5WAgmjA1jG55LJF5kcmV7B/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=py6Re3f2afA0gWVcNDsM1h51mUx/u6mC0qdMg2+iOZB0UpdWn/p5co5DnbGeVjvd4XHcq7cmFp0FT/f4LDKqqc2H8DmTmoXp+qrtrJR+zwtJIMiV0LGNLa9GYq6rgBbGkB7hLrwGzovZy6hpRj7NWpgaEHVpS8IbpyNYRmF4l/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aavlEQUN; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47ee4338e01so4025305e9.2
        for <live-patching@vger.kernel.org>; Thu, 22 Jan 2026 00:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769070862; x=1769675662; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=unjwSicxh/p6Pdh6zOxk+15CQX9Jqpe/B74PqYozyAs=;
        b=aavlEQUN+kSrGW/kzvOwhIeIv4z3WVQxtDSwPSnKtiQhsXuHfGLSISQUs2aszEVLkx
         zkldq0LW0Lc4Sj0agmEy6ViSfML9ZrFl5vcD0aRCkqtHQI60IcBC07t9ArN/+PucvEsJ
         J49/czabYtRy+6Emed2/EYyFEBdnGQEFO4gHOmCpo9IE2B8azV+zJZP8liI/0Std97x1
         LMwbKYHtEsfU25MNVc/N/zBcxHr5LY5IrFGlrJe/bgu45dY0n0MiF4trVzkmfp+1wACf
         +DyV997E/e60Qhnk324b6ZogRC5xZkwJAD2HTN+2EJgfTONR83du1yOsmg/zOHPHtYFn
         fJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769070862; x=1769675662;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=unjwSicxh/p6Pdh6zOxk+15CQX9Jqpe/B74PqYozyAs=;
        b=sEQKPYWmvUb4dXYF60Snqnbg3XAnfhnPshDlGp7ECPwdrngAUdATrm8d7Jov8T0d3v
         DPxMiLJn2Bf5Ll1c15afpVTEMJIOBdd24nAn0BjPxbdowyuuMpTWsQeSNky/kitWjVDB
         Zmj9kvlVbFbUcog4XKYdlHU1uSUYziv260Rtv7h1BlLyeqI+3LcGAQe3NxIaEr4xb25Q
         bJoD+0boFvT6xOH7jVhm5pYApIaA+1L8yO7ECwOcQhMT/R0IxN5PIb2Y9sTMw1MztrLR
         vpVHnbXs9B9s0lrZ12qIADNPWSgs7dO2WZvajJSIKL0A1CwANojQ8SJxTI2RqJ6ZlrSw
         aOsw==
X-Forwarded-Encrypted: i=1; AJvYcCUO6YEDc0iA11S/YNyrDgJZMTfSG72JhUSR87RJEFddNlTU1wMP4hgf0uYp6PIvTHRHDV5IQ6FybH7RcY80@vger.kernel.org
X-Gm-Message-State: AOJu0YyGBPPLavrKYNjsN1fndMtYqpdffVI3fr1hX4uAMT1wqx+CpEFy
	yos9eY/BbSirTVSfC8VE+UTevBOZGHDPPElNWq9jGiOjbg9AEaUmoouOMdNgmCKl9mI=
X-Gm-Gg: AZuq6aKJoNYy+tWcrspYzMlSEWrTUZS/FJl8AXnrvKaY4JJTc3ZGeyLK4ax/xlErAgG
	MyoOyx55jaZ/prIPTqZaFL9WcmVHRXxrSkMCDkWD1MTF0IrlsTdTeDD9CXBcXFLz0ML7SVcwlo6
	EkXGMh9qg/b8E+ctnexbI3+zAvbPz3U3tWrnSx/OxfPHouAUzYKIrqtDMCxgEIStfz4vmWmhCmO
	zqBnm9uHurcRx+cyFqMZj1RmpXu4WUiuf2Gw3MePXmOw4li106IMJjNuyZ3fSf+GjrN8DFgFZV/
	Smf99wPSjh2wfGmBk0RY1k10wEv3lurcHWAKAdBnoXAXSfupWrYZySojJYQnv+DaFkbUujDIpmw
	QK1gXCMvA91xsHyKGH5fUjXIsysxjgPDBzJhV9KO4xSdywthXvn7ghz+E4N1hX3TbmbzpeiNgya
	VwIRHlKCb3M17fvEH3TivBMdzPkQbkl7Ub8K6+Zb6yASrfMduZpepRE8auGPgA2zCVFN1sRI1xu
	wXMwjCTqh5UhGGKgjIq60Z4p1axkfv0fu8P9fHebtF8xLsIdwr1Qo/lbOZSP31Zlu9E+XOB2rfs
	mvw=
X-Received: by 2002:a05:600c:8285:b0:477:8a2a:1244 with SMTP id 5b1f17b1804b1-4801eac3169mr237845285e9.11.1769070862531;
        Thu, 22 Jan 2026 00:34:22 -0800 (PST)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804244c6cesm50432815e9.0.2026.01.22.00.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 00:34:22 -0800 (PST)
Message-ID: <30b09639-42e3-48f5-8e7a-12d2589f20e4@suse.com>
Date: Thu, 22 Jan 2026 09:34:20 +0100
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] livepatch: Fix having __klp_objects relics in
 non-livepatch modules
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>,
 Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Peter Zijlstra <peterz@infradead.org>, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260121082842.3050453-1-petr.pavlu@suse.com>
 <20260121082842.3050453-2-petr.pavlu@suse.com>
 <okmrns5zlxqkwrou5rspq3zyakuv4gwwe4do7yovjbeaa5eajh@fud5amphpycu>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <okmrns5zlxqkwrou5rspq3zyakuv4gwwe4do7yovjbeaa5eajh@fud5amphpycu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[suse.com,quarantine];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-1917-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[petr.pavlu@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 8C74C63513
X-Rspamd-Action: no action

On 1/21/26 10:04 PM, Josh Poimboeuf wrote:
> On Wed, Jan 21, 2026 at 09:28:16AM +0100, Petr Pavlu wrote:
>> +void *klp_locate_section_objs(const struct module *mod, const char *name,
>> +			      size_t object_size, unsigned int *nr_objs)
>> +{
>> +	struct klp_modinfo *info = mod->klp_info;
>> +
>> +	for (int i = 1; i < info->hdr.e_shnum; i++) {
>> +		Elf_Shdr *shdr = &info->sechdrs[i];
>> +
>> +		if (strcmp(info->secstrings + shdr->sh_name, name))
>> +			continue;
>> +
>> +		*nr_objs = shdr->sh_size / object_size;
>> +		return (void *)shdr->sh_addr;
>> +	}
>> +
>> +	*nr_objs = 0;
>> +	return NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(klp_locate_section_objs);
> 
> How about we make it even more generic with something like
> 
> void *klp_find_section_by_name(const struct module *mod, const char *name,
> 			       size_t *sec_size);
> 
> ?
> 
> I think that would help the code read more clearly.
Ok, I'll update it.

-- 
Thanks,
Petr

