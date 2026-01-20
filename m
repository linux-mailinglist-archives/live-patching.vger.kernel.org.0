Return-Path: <live-patching+bounces-1912-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2PdWEBnGb2mgMQAAu9opvQ
	(envelope-from <live-patching+bounces-1912-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 20 Jan 2026 19:14:49 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DCAA2493BF
	for <lists+live-patching@lfdr.de>; Tue, 20 Jan 2026 19:14:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7E3A53CDD25
	for <lists+live-patching@lfdr.de>; Tue, 20 Jan 2026 17:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB8E441030;
	Tue, 20 Jan 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KUuGFci/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC1644BC82
	for <live-patching@vger.kernel.org>; Tue, 20 Jan 2026 17:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768931331; cv=none; b=r5pD4CUKJ88XK5QYiWgrwfz6pin6t/M9FRJ3aqOJgR+QU0Oh2o2nwPlTkLuTu8NX+ppBmvTuXHVJNLBfKzbXDP8EQopU++KU8euXg26UTtJQpwRXcTE8NxQMSPagEoKGWb9jb2mVxLqUfgBAwmOiFcWAY4r9DBhB7c51C1MOGf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768931331; c=relaxed/simple;
	bh=p9HBvfleLKD9Mm3BCduxT+gNH4pFHTcfkAq3YRn3pp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sHIb2w6AQp62sLcEZt5LM96/0juuPn+AYoxPI4ja3iucyryzBmVfflX46RizPWUupjgq4pC0aJNeLj51omUon07bawejxRCLGlj7I+samPIsPPxJC2R2mCpwU12Dy336+k3GXFA3AVy+Qw9QlkAZqklBtrnujdMIyUC5g7iBg8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KUuGFci/; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43596062728so46118f8f.1
        for <live-patching@vger.kernel.org>; Tue, 20 Jan 2026 09:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768931327; x=1769536127; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y4NQyrvOF1Xb3Li7xprOo6Y0AJeuh4LSApnAookisqA=;
        b=KUuGFci/SfOQDNHrWq2dsSTPS0XRYjIjmHf8qMs6vJwl3MY3CWakxBmxUje8FjsVpg
         yG4H8k1QhpFgw4bD/CkpO8aZq9oG6ade6RBkbE2Z82w7Ldnn9GH/SOp5wF4i+Dpfu4ei
         IB6+nWOq2X0SCMnUHzYlgHrcPJ28P7cXAvsiH/2nUkFT62QOWoAl4TpxBCL3kT8dcVIv
         TpYUulhf6DELnQHfiUf/Ef3t4q9qj+7O/dblet5N/tHDZMBP5XyLUxofETf1323m0qpS
         U1m4UyOeZVAHUwPFY/nNwauxI1/lKbok9itERNK8nv9X+eLbxwzZFjDN4OF5/iSZXBDf
         ZMaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768931327; x=1769536127;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y4NQyrvOF1Xb3Li7xprOo6Y0AJeuh4LSApnAookisqA=;
        b=Usobh9nH8DTvBkQNKxUzEW51h9GecCWS7nqoYPXKeIe0At7Q2WrM/0BpjWBDwWPYtx
         NSsvSWjsqyHQt1ZZHK+iFNVKE/+DvABiXdfFPDEMrOgDBIASZSGs/oFAiJu7PXyv90NP
         x3yzhPhZiaKfR8yqCWoHVy+Vmnq9RQO8PGqWiVwzme+ZBHAOkDL2HCUgeg4ad6d8h3cQ
         uTXQtG31zdCKska3Q9xRvSXaUuWyAhSX0HshWMnw4byVB/bdQgluMKLNhcWUM6BKsewM
         lnJLDybbWIwFCqJqGTlIogU2fYAgl/nBdKY9QaWFpmRPHzDQSD4aV0XTjqkWmsyTHpOG
         2iKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtrYkWLSJWM4EYDo82nfxKmhyLlCHuGL+VT8FTGKSdsYHXGA3bwCrne0gVraBaO1+G5crExdI/2ibzbLJX@vger.kernel.org
X-Gm-Message-State: AOJu0YwL4vGCamy2aRg5TN/vOOoPVXGCvRHOoAFCqlkiZNUz0uBNAtEz
	yovpnr3d1oQNbXqHkIGhN4h9wYpUR152FPUXgRZ/CPxQWBKMCkmA5hzYmzYY1LoLePY=
X-Gm-Gg: AZuq6aLpJpPHc8Awo2INZgFTxP6t6LOih7NBCwD1X9cOpVdkdh3+KrtLmVxeDi5UaFQ
	CGaz3jVgYfhpo1W0+xf6U1IAK+qBXY947xJZOiN+m/THRmdc1iRRd3RVnnp2ZujQmFEenvWq3Eg
	v/udpPDTvDUsN7S3nzBGo8pDsVeUWXcBPfTnpzvPkkV707oVEuuEGybHlTB6URKZ7NnTI0efwHZ
	YzFAPivgZBedwm9DEiiTXabyxjoXBejcirTu/Clwn8ecKSe5z3/8BmIzqxvpN7E7Mqs0XzjeI9a
	TCQThCXU4GoxqPzmSU3sUkZVxzMMzyIzdFWNSFyAzgmPt2HRZCWqnQOmsiMdYzhh2u+2anx7xaQ
	2JGOOzi/1xq494dEwl9OUcvW4+pGWaPzWDp2TfkRj/NTzyRQTPrzpJpkFLe0fdpSxu+QlzmVQy9
	FU1pYlCcVw2O7Hr7h/GqrHsCmaEXGAtw==
X-Received: by 2002:a05:6000:4312:b0:430:f593:aa34 with SMTP id ffacd0b85a97d-434d75c15a7mr29786562f8f.17.1768931326921;
        Tue, 20 Jan 2026 09:48:46 -0800 (PST)
Received: from [10.0.1.22] (109-81-1-107.rct.o2.cz. [109.81.1.107])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996cecasm28562475f8f.26.2026.01.20.09.48.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 09:48:46 -0800 (PST)
Message-ID: <c753a5cc-e654-433c-84be-189185182250@suse.com>
Date: Tue, 20 Jan 2026 18:48:45 +0100
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] livepatch: Fix having __klp_objects relics in
 non-livepatch modules
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
 Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Peter Zijlstra <peterz@infradead.org>, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260114123056.2045816-1-petr.pavlu@suse.com>
 <20260114123056.2045816-2-petr.pavlu@suse.com> <aW6uCQNXj0Y7IGnz@redhat.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <aW6uCQNXj0Y7IGnz@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[suse.com,quarantine];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-1912-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[petr.pavlu@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: DCAA2493BF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/19/26 11:19 PM, Joe Lawrence wrote:
> On Wed, Jan 14, 2026 at 01:29:53PM +0100, Petr Pavlu wrote:
>> The linker script scripts/module.lds.S specifies that all input
>> __klp_objects sections should be consolidated into an output section of
>> the same name, and start/stop symbols should be created to enable
>> scripts/livepatch/init.c to locate this data.
>>
>> This start/stop pattern is not ideal for modules because the symbols are
>> created even if no __klp_objects input sections are present.
>> Consequently, a dummy __klp_objects section also appears in the
>> resulting module. This unnecessarily pollutes non-livepatch modules.
>>
>> Instead, since modules are relocatable files, the usual method for
>> locating consolidated data in a module is to read its section table.
>> This approach avoids the aforementioned problem.
>>
>> The klp_modinfo already stores a copy of the entire section table with
>> the final addresses. Introduce a helper function that
>> scripts/livepatch/init.c can call to obtain the location of the
>> __klp_objects section from this data.
>>
>> Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
>> ---
>>  include/linux/livepatch.h |  3 +++
>>  kernel/livepatch/core.c   | 20 ++++++++++++++++++++
>>  scripts/livepatch/init.c  | 17 ++++++-----------
>>  scripts/module.lds.S      |  7 +------
>>  4 files changed, 30 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>> index 772919e8096a..ca90adbe89ed 100644
>> --- a/include/linux/livepatch.h
>> +++ b/include/linux/livepatch.h
>> @@ -175,6 +175,9 @@ int klp_enable_patch(struct klp_patch *);
>>  int klp_module_coming(struct module *mod);
>>  void klp_module_going(struct module *mod);
>>  
>> +struct klp_object_ext *klp_build_locate_init_objects(const struct module *mod,
>> +						     unsigned int *nr_objs);
>> +
>>  void klp_copy_process(struct task_struct *child);
>>  void klp_update_patch_state(struct task_struct *task);
>>  
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index 9917756dae46..4e0ac47b3623 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -1356,6 +1356,26 @@ void klp_module_going(struct module *mod)
>>  	mutex_unlock(&klp_mutex);
>>  }
>>  
>> +struct klp_object_ext *klp_build_locate_init_objects(const struct module *mod,
>> +						     unsigned int *nr_objs)
>> +{
>> +	struct klp_modinfo *info = mod->klp_info;
>> +
>> +	for (int i = 1; i < info->hdr.e_shnum; i++) {
>> +		Elf_Shdr *shdr = &info->sechdrs[i];
>> +
>> +		if (strcmp(info->secstrings + shdr->sh_name, "__klp_objects"))
>> +			continue;
>> +
> 
> Since this function is doing a string comparision to find the ELF
> section, would it make sense to open up the API by allowing to caller to
> specify the sh_name?  That would give scripts/livepatch/init.c future
> flexibility in finding similarly crafted data structures.  Disregard if
> there is already a pattern of doing it this way :)

Makes sense. I'll change the function signature to:

void *klp_locate_section_objs(const struct module *mod, const char *name, size_t object_size, unsigned int *nr_objs);

-- 
Thanks,
Petr

