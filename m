Return-Path: <live-patching+bounces-1428-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97AA8AB57B1
	for <lists+live-patching@lfdr.de>; Tue, 13 May 2025 16:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E37123BE7D6
	for <lists+live-patching@lfdr.de>; Tue, 13 May 2025 14:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C871C84CE;
	Tue, 13 May 2025 14:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="zr7WqQ6v"
X-Original-To: live-patching@vger.kernel.org
Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0741A83E2;
	Tue, 13 May 2025 14:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747148115; cv=none; b=uhtZZDS6NI8woztlbxcQZ4imwqOU9ArZJ7yCIT9jY41FElXit+yunS3J8Ooc2ZRmw4FIaIGcYVKgPP9/0VDo5EqrvhUFmq7D/d2U9/cTX3Wi0HtDndYrvF+iFp29O0UlAiLQP0cVBrypgwS1nxEncdd63oek5vJ+tEm2NoeDtXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747148115; c=relaxed/simple;
	bh=xF0FR3rPcOBGp88yQz2/gAEWMOvIBDpTeMGj3UrPZoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GNMInxchZ5Cj6np9ZlmQQiCv6YYLQxSqwJvQhTg9WUw3/PVBxt3CFNi6WfZ8aLBjXpferrCAKMl7k6nb9lzEau1rRLmsRH6ssyt8+yLiXFBr4pxmB/Dai3PXWKdGn+CEhNifXa3iKPcfH+7dEAfSCJ4+tSd6F9RdqtsCM2+HOZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=zr7WqQ6v; arc=none smtp.client-ip=203.205.221.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1747147803;
	bh=vBwPAS74bANjhaoHDiOSBCA9pMoLahUbwD6Y8CSTj64=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=zr7WqQ6vLFpyChvw7pDqeJaKGgmQdsWXKIpBq9BJoHvQDYkX1++U7xYKmEoRU4l0R
	 ORzm+aEIE4T6CIVdeG7PBC2hj05r45S0eIindIO0YAMNvd4KyUovPbpuBVNr91phJQ
	 nDnDTkZpuYdLTWPF4pi8rdFs+6u2n7NnuC8QwJFE=
Received: from [192.168.3.9] ([221.200.22.204])
	by newxmesmtplogicsvrsza36-0.qq.com (NewEsmtp) with SMTP
	id C7BB22AA; Tue, 13 May 2025 22:49:59 +0800
X-QQ-mid: xmsmtpt1747147799tw9xxxoiy
Message-ID: <tencent_8AACB6DF7CFB7A9826455C093C0903B15207@qq.com>
X-QQ-XMAILINFO: OIJV+wUmQOUAf2UFzEHsFZSYYq4PEi+fUZaybgZnx8ZUEF9jFksjOdQTSAf1Ig
	 WRj7hd9aqX6VeNnen9UmrJOnrqGPuOZ9D1bXwIdM/1O0GEiSVndKRLE+bAPLd5xK/rLM37gb0uH7
	 Xgk4uo3jDZl/DoqXK7sCPCJ9giUCAwi7ASHybmn4K/AUt4IKNq0SfF33lFRxLEO8Cs8XTC691mht
	 bTwTtBMLbcmo0zu2WLEL+Uwz/KQrwA1+DjRRTV0uPkKSLd2EDXxr5qdGO3BpUzVg0qO+smbhYZUn
	 hupDAxGHtGZ1wl3PB2VFBFnsbnvQIzbi9t/txyknnl1J7gJ8PHcl54OyY22lrzuLvgnNViByfEax
	 1tWIIAqgQAJnWXSZ9NV4KFxoJUn2BLiIWyCHPuADj4sO/9IknAXtAss+94xMDkZmQogK2OqhhDau
	 hVo5O6ZvR0iKBGdHMx7Pb1l/1rxBlEjRZPr1DgNVHOrncC8OxafOVtGM+GKINDpPCDCQ6B8bMYKL
	 c+yLCUoh0YpS2DxJRZ/J0H/xLoyv+ioo79K3uM3WzaI22Sbmm510vwZMMPebKuutCctEQXNDjyxK
	 NPQZvC/kWxxTd/twih84iuEo210v9khUWzDEUX/p/UViVUHGAcxEEvpgyBQRAVjqgiOo4pTz4EwV
	 ApNo1sysQw8Gne8U5+VD0nxIbGpANqZ/9RlhL8fN3HMN5cT0lTNuykHoTRH/N091lIqcHXiEHKCI
	 H0yJHSNeYXQn934qHif7MV2TqdONEEhApa+1edI/TiHaLAvt41afonpBvvbTWNS/BV/uJgHGzSvn
	 B0WLdDgvtgw2ras0QFn3wv52nfQYbrKAbfZjMCluGifIXlDqFIaEo2rBqQAJMjOIIpkLMPqO/Rzi
	 MDlE85HjjdmK+1vU0jffUiNX23VefUULmEcmbb2PPn7WTGm0H3XuJk3Z9chbnRy0YlczyeuBlgaF
	 7y9wC6prmFKUOjWxLDxl4SxufDl8Wi
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
X-OQ-MSGID: <8b8d4368-286b-4f2a-a189-22591a99d1cb@foxmail.com>
Date: Tue, 13 May 2025 22:49:59 +0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
 Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>,
 Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
Content-Language: en-US
From: laokz <laokz@foxmail.com>
In-Reply-To: <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/10/2025 4:17 AM, Josh Poimboeuf wrote:
> +
> +#define sym_for_each_reloc(elf, sym, reloc)				\
> +	for (reloc = find_reloc_by_dest_range(elf, sym->sec,		\
> +					      sym->offset, sym->len);	\
> +	     reloc && reloc_offset(reloc) <  sym->offset + sym->len;	\
> +	     reloc = rsec_next_reloc(sym->sec->rsec, reloc))

This macro intents to walk through ALL relocations for the 'sym'. It 
seems we have the assumption that, there is at most one single 
relocation for the same offset and find_reloc_by_dest_range only needs 
to do 'less than' offset comparison:

	elf_hash_for_each_possible(reloc, reloc, hash,
				   sec_offset_hash(rsec, o)) {
		if (reloc->sec != rsec)
			continue;
		if (reloc_offset(reloc) >= offset &&
		    reloc_offset(reloc) < offset + len) {
less than ==>		if (!r || reloc_offset(reloc) < reloc_offset(r))
					r = reloc;

Because if there were multiple relocations for the same offset, the 
returned one would be the last one in section entry order(hash list has 
reverse order against section order), then broken the intention.

Right?

Thanks,
laokz


