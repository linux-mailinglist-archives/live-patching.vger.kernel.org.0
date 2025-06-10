Return-Path: <live-patching+bounces-1510-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D518AD375B
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 14:53:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 533C76C09AE
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 12:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D92C29AAF7;
	Tue, 10 Jun 2025 12:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KxwS8Rx8"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB3F28DF02
	for <live-patching@vger.kernel.org>; Tue, 10 Jun 2025 12:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749559157; cv=none; b=AlyYeTaNtm4U3/smz3acIh4zTUM0kVmJF/bsoBe1VwUZZKTSTdzwbqBXMq9rGndM/uItH7PiprNZ99Ce+15nVLFkGEC/XykrVSKog0e07NZxXhlXaTAptEXXmJb1HESt+dZCS6I/1xel0VHiP4aMmb0OyK4ZH3nj6jUqv4aIIC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749559157; c=relaxed/simple;
	bh=T66r4gVAnul0OYfQDLj19mG5+M3khwvsVzj6fPcpDe8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ahXlv4RcSlEQrqO8oBDB/XcvUtVAzGAso05eyZuvUe1KHbO5fhp+kTR9kXbt2CHtqZZcx89SIQDDWL1gGPPWn6Dighv+evpL+hHQCeVOi/w3RxQsixHfVlcxxXYz4hgbL51MBhLrh436qcqp0y3PlwvFX5wWHS93RrxGjegNAjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KxwS8Rx8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749559154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eUwawhNYuhEkX90HugvBjWWAN8NSeCXittI1isZSvAg=;
	b=KxwS8Rx87ay8qqEN4dtQWm6pAa6skEIz/vFcvNSwLCH32xXnkqSUEEQagavo/Op3ZtQNgt
	5SGsn0K1TqfLTDfhFN6Pw4xs3ZZNY0RNHBD3gEo1p936NG/JQWq8d8g9W6vVzWi8b3B54L
	0HaEzLTFfqSetLLvTEqhiQN24pjmspI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-ooSjFjfqNzakceS5jHNPiw-1; Tue, 10 Jun 2025 08:39:13 -0400
X-MC-Unique: ooSjFjfqNzakceS5jHNPiw-1
X-Mimecast-MFC-AGG-ID: ooSjFjfqNzakceS5jHNPiw_1749559153
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4a42c569a9aso105607631cf.0
        for <live-patching@vger.kernel.org>; Tue, 10 Jun 2025 05:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749559153; x=1750163953;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eUwawhNYuhEkX90HugvBjWWAN8NSeCXittI1isZSvAg=;
        b=Z5FhqIVtEq8XI6pdaMwOhGv77jsqcnuO/wq1AlnDiXW0FmlRUeSdrgXDUsI6m6TWLV
         T6RHODpKMLsiSMVSj4xSy4oyKXRvj48aGrUw5GPdBkoAldC8pBvoGYSbDTsrDYvLK8CR
         GG0zKCNdgbjKl7d0bymwBnUKupQjx1ejVOjHgv5Gu3G8Hvfgc3sVCcOVy61hS9PPGcY7
         wY4SMKFusxysexjFKVPFJbwrTZ+Udcog14m/jFxO3QO931+qs461raDJA2TF4MUDqIya
         Gb3nQpzvAR5UjGa0PMgLqNAE1cU6pbE6kqxajl0PUmRYDmFYPHfEg4Yu+DYp/MYqPieo
         oGBg==
X-Forwarded-Encrypted: i=1; AJvYcCUNQGn3hIqiiekVD+AxJm+ZwYTB4/hwH4QmXBKdvqucj9ZX1TD0JZR5qLu61V3eTMEvGodwR05THDRBZDMz@vger.kernel.org
X-Gm-Message-State: AOJu0YyqhiYxVLcXwQXv/x6FYVXYoJXKiFuNsHqE6Z/tHt+Y6qJ5fx8r
	x67hBX30z/x1gWFX6I2YffbB/mCef1+X4UBgrbYgl7YkGzD82RmEdT8Hn0ClmCzaG7j9CR55dCt
	dGsBppNbxZ4z3jSjOY4R014xlQusSkG0sHpvma5eB/6mwgXPlFFGT7187SAMFtLz5AAo=
X-Gm-Gg: ASbGncupJJbo52XFXn4tAMwCYPczYYQBufB5sdtrEUUOND9yCdaYwrqtmgG9X64wloi
	MVhpXlGuVd6pF9wn/CK9m/7+PlhlS32sfm225LyVUDpWq04BaNfas+MPAlRtTwGpD7kvooURJFd
	aYRmJsIZz4nhCJXg6hYrZUC7Juv4/bXiJ4m8TLS1kPQcuI3a3PxZSESIth/Ou9OOMSz5uESuBib
	5UHvKeI5otCdhNVa50YiSd5Me3ssOXFwHlaFOS/JzcAcaoTMx7MMkRzlWEXkY28kouxyaS9raBS
	MiqwyTNbvf5oHucDQDcokGiym81Bn6iWXaMbOr+IIEvjZL6RlMsNn/XM7Vtc/gWrEyWJNrToP5L
	l/g==
X-Received: by 2002:a05:622a:2303:b0:4a6:f9e3:b08a with SMTP id d75a77b69052e-4a708dd2c18mr58020691cf.26.1749559152754;
        Tue, 10 Jun 2025 05:39:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHztNv3VObOgToXSTv7riwGA9QFsukZ6DvwIeP7g375MTUD805iivys7riz1H2MkTmJrMnxCA==
X-Received: by 2002:a05:622a:2303:b0:4a6:f9e3:b08a with SMTP id d75a77b69052e-4a708dd2c18mr58020161cf.26.1749559152402;
        Tue, 10 Jun 2025 05:39:12 -0700 (PDT)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a619852fe8sm70875971cf.52.2025.06.10.05.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 05:39:11 -0700 (PDT)
Message-ID: <6f93bb5c-43da-4a88-a8b3-7b7ea992b0e6@redhat.com>
Date: Tue, 10 Jun 2025 08:39:10 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
 live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
 laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
 Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>,
 Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
 <aEcos4fig5KVDQSp@redhat.com>
 <2oublab5wrfzneispi4sqb6feiw2abc3mzxozmx53btuvseljh@3qsmyluomyir>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <2oublab5wrfzneispi4sqb6feiw2abc3mzxozmx53btuvseljh@3qsmyluomyir>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/9/25 7:21 PM, Josh Poimboeuf wrote:
> On Mon, Jun 09, 2025 at 02:32:19PM -0400, Joe Lawrence wrote:
>> On Fri, May 09, 2025 at 01:17:16PM -0700, Josh Poimboeuf wrote:
>>> +static int validate_ffunction_fdata_sections(struct elf *elf)
>>> +{
>>> +	struct symbol *sym;
>>> +	bool found_text = false, found_data = false;
>>> +
>>> +	for_each_sym(elf, sym) {
>>> +		char sec_name[SEC_NAME_LEN];
>>> +
>>> +		if (!found_text && is_func_sym(sym)) {
>>> +			snprintf(sec_name, SEC_NAME_LEN, ".text.%s", sym->name);
>>> +			if (!strcmp(sym->sec->name, sec_name))
>>> +				found_text = true;
>>> +		}
>>> +
>>> +		if (!found_data && is_object_sym(sym)) {
>>> +			snprintf(sec_name, SEC_NAME_LEN, ".data.%s", sym->name);
>>> +			if (!strcmp(sym->sec->name, sec_name))
>>> +				found_data = true;
>>
>> Hi Josh,
>>
>> Should we check for other data section prefixes here, like:
>>
>> 			else {
>> 				snprintf(sec_name, SEC_NAME_LEN, ".rodata.%s", sym->name);
>> 				if (!strcmp(sym->sec->name, sec_name))
>> 					found_data = true;
>> 			}
> 
> Indeed.  And also .bss.*.
> 
>> At the same time, while we're here, what about other .text.* section
>> prefixes?
> 
> AFAIK, .text.* is the only one.
> 

What about .text.unlikely, .text.hot (not sure if these can come alone
or are only optimization copies) ?

-- 
Joe


