Return-Path: <live-patching+bounces-1458-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E25B5AC2223
	for <lists+live-patching@lfdr.de>; Fri, 23 May 2025 13:46:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F397A3AADD3
	for <lists+live-patching@lfdr.de>; Fri, 23 May 2025 11:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F2523536B;
	Fri, 23 May 2025 11:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f5c4Ngdi"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE88722A1CD
	for <live-patching@vger.kernel.org>; Fri, 23 May 2025 11:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748000790; cv=none; b=reTFl1zBpH79M8ihqXsfe30dgNGVFT6Apt7gM07moCYfJgbDsHMAExhF5b+3hhyrHs7683Q7UnUTYioA8vjD+7uLaOMsCTRxXEnL4qFCw9qNXUYpj7npzBI7Ydr6O9eYnawTmSF0iLMzeoGvRE7qPLUCSVyJ5N/a6130/iOPJYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748000790; c=relaxed/simple;
	bh=tINtbMZwiyul1+s615FxcsqdDp4S0HiWbZTcY2k5exg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=siItlqKHNpxNH/Wm4kDUS6m+2pN5f2fihegpNIpotRt8mjhlNnuoF3x2PqmdBE+NKPz0aiXjT0OmPy3TfzfmyVVGF1hA81et+2EW8Ggh6mR8vvHfp7Lh1Ne/NrttMnQsObvPwAGDFT0t6HsV4tDtemNQleV7THW2m6ycbxcRSb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f5c4Ngdi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748000787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+hWcM77IoP384h3TPLegN4v3sX3yuXb0odhYXhpeKHU=;
	b=f5c4NgdiLAPLhCXc7sxFhfwcIDggL3ZxaCct4ynlLBqMpIIAnnYRqoukDQzKIRgd+2KjA/
	cUGcyFvONGkXJFN5rt4jtxh1w7bqeUeTjJq5jG2lt/rCYZap3mTVVMQoRgwnmmIFd2jAws
	43Oab1G1LwVHF9odAjaX5Ipf3vHrhO4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-sWE-2y0_OE6XUUBFbm01Yg-1; Fri, 23 May 2025 07:46:24 -0400
X-MC-Unique: sWE-2y0_OE6XUUBFbm01Yg-1
X-Mimecast-MFC-AGG-ID: sWE-2y0_OE6XUUBFbm01Yg_1748000784
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c5e2872e57so1617359885a.0
        for <live-patching@vger.kernel.org>; Fri, 23 May 2025 04:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748000784; x=1748605584;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+hWcM77IoP384h3TPLegN4v3sX3yuXb0odhYXhpeKHU=;
        b=GZd6+VLcKQBsnG+IQG46RfWF//EMCik4rbW0bMwM/cv7zRZJYL3peDnfdoZtAEo9Gm
         jRLyWQuTWat6RTjPH0ZTJqGRt9+1rqDwrd0lr/4fg/A0ihZzomx4eVt3kTeuQzTgs033
         Yj7vNfGgqdDR7cuM39RK6Iw6z0xf0I+ymMQkKzbh6HG3Yp8Apd+/R91V/fptQlbHprTF
         jA1ta+rzvOmUSHjt3QoKor+AZvpXK4jJFuN5P5A14MS1uu+jyjjmORlsnnXUPfuur/3z
         xHeZm1q/H/7yB4f7s243ZxackwVgJBcFOkqj+MNbmKb8y/Mrz4TSc4HXItJsohJWq2PF
         wAbw==
X-Forwarded-Encrypted: i=1; AJvYcCXcY96QO9gDs117A91ATSJJRhXMS0C1BZwwomu+NtcCsHhMdNagX0RLZfI4XMhVTr6vWQIJqXav4SDrVlUa@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe9Lz/m9XW6RK6zXzqZypipViNgiIRXGVum9Z6v7VIZD/l1WW6
	vTEdVU6YopZ3HVfqwPvPOBNCuGaA+Mn0i01j05U7AMjAT/GeP/YNMpqx63ElEJy38HK1GMV2lqh
	m/c0jyVR7c/AcD0l3r6uJ0w3WFgbEYVSzQVK8NAP70c78onlpIZSiM5Bht531mOSt2Oc=
X-Gm-Gg: ASbGncueLq8beSmOL3mXsyV5okvdC7bEH/gu4Sx9YAniej/AZYema1aps1SY6OwUN88
	CbL9cRmX+Z5m/EgXwox1tttwbv1xAtld6C+nwZWufBjTRgpO+Csr/PZpxFyfeef/eFxhfuDMkER
	JzGIjmnOJe5k5uoGVznDqo9rCQFIsVBU7yNc9UgpXCAkBFSydKMgL/C8F/SYTvapJlYWPIAoraJ
	oOyfm/zHcRCxOYASQV3aJl/9F6TgNMYXUy7RmLg2RochRBAr/7ci9OzgTA5sv+gVfKhGvKSJpSn
	2wqNlQSpSGY2rXeQlp0+wiSqXUqelRr6gYi5BKeYzrg64fKTvxLDo34m88zwyXf2Udo=
X-Received: by 2002:a05:622a:5c1b:b0:494:7c68:3c6e with SMTP id d75a77b69052e-49e1df237d9mr37122721cf.15.1748000783891;
        Fri, 23 May 2025 04:46:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGh3nDU8DMvp2LUfvA1rvQXn+mK50bZw+xd7UbP2Ohi0mNvNMwTvTiS0vjD5CL+WdJ4AaPr6g==
X-Received: by 2002:a05:622a:5c1b:b0:494:7c68:3c6e with SMTP id d75a77b69052e-49e1df237d9mr37122461cf.15.1748000783501;
        Fri, 23 May 2025 04:46:23 -0700 (PDT)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd468ccd94sm1166694285a.109.2025.05.23.04.46.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 May 2025 04:46:22 -0700 (PDT)
Message-ID: <29b3d533-94cf-4949-90a1-4a8c9d698a8a@redhat.com>
Date: Fri, 23 May 2025 07:46:19 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 35/62] objtool: Refactor add_jump_destinations()
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
 Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
 Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>,
 Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>,
 Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <70bf4b499941a6b19c5f750f5c36afcd6ffd216f.1746821544.git.jpoimboe@kernel.org>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 xsFNBFgTlmsBEADfrZirrMsj9Z9umoJ5p1rgOitLBABITvPO2x5eGBRfXbT306zr226bhfPj
 +SDlaeIRwKoQvY9ydB3Exq8bKObYZ+6/OAVIDPHBVlnZbysutSHsgdaGqTH9fgYhoJlUIApz
 suQL0MIRkPi0y+gABbH472f2dUceGpEuudIcGvpnNVTYxqwbWqsSsfT1DaAz9iBCeN+T/f/J
 5qOXyZT7lC6vLy07eGg0uBh9jQznhbfXPIev0losNe7HxvgaPaVQ+BS9Q8NF8qpvbgpO+vWQ
 ZD5+tRJ5t85InNiWR3bv01GcGXEjEVTnExYypajVuHxumqJeqGNeWvx26cfNRQJQxVQNV7Gz
 iyAmJO7UulyWQiJqHZPcXAfoWyeKKAJ37YIYfE3k+rm6ekIwSgc9Lacf+KBfESNooU1LnwoQ
 ok9Q6R5r7wqnhCziqXHfyN2YGhm0Wx4s7s6xIVrx3C5K0LjXBisjAthG/hbPhJvsCz5rTOmP
 jkr+GSwBy2XUdOmtgq1IheBFwvWf08vrzNRCqz3iI1CvRpz0ZYBazmkz924u4ul6W7JuCdgy
 qW3UDLA77XlzFrA7nJ6rb77aZF7LJlkahX7lMaKZUzH+K4aVKTdvZ3szm9K+v0iixsM0TEnz
 oWsZgrkAA0OX2lpLfXvskoujQ84lY989IF+nUwy0wRMJPeqNxwARAQABzSZKb2UgTGF3cmVu
 Y2UgPGpvZS5sYXdyZW5jZUByZWRoYXQuY29tPsLBlgQTAQgAQAIbAwcLCQgHAwIBBhUIAgkK
 CwQWAgMBAh4BAheAFiEEXzkJ3py1AClxRoHJx96nQticmuUFAmF2uf8FCRLJJRQACgkQx96n
 QticmuU69A/9FB5eF5kc392ifa/G6/m8q5BKVUXBMWy/RcRaEVUwl9lulJd99tkZT5KwwdIU
 eYSpmT4SXrMzHj3mWe8RcFT9S39RvmZA6UKQkt9mJ+dvUVyDW1pqAB+S6+AEJyzw9AoVPSIG
 WcHTCHdJZfZOMmFjDyduww7n94qXLO0oRMhjvR9vUqfBgEBSLzRSK96HI38brAcj33Q3lCkf
 8uNLEAHVxN57bsNXxMYKo/i7ojFNCOyFEdPCWUMSF+M0D9ScXZRZCwbx0369yPSoNDgSIS8k
 iC/hbP2YMqaqYjxuoBzTTFuIS60glJu61RNealNjzvdlVz3RnNvD4yKz2JUsEsNGEGi4dRy7
 tvULj0njbwdvxV/gRnKboWhXVmlvB1qSfimSNkkoCJHXCApOdW0Og5Wyi+Ia6Qym3h0hwG0r
 r+w8USCn4Mj5tBcRqJKITm92IbJ73RiJ76TVJksC0yEfbLd6x1u6ifNQh5Q7xMYk0t4VF6bR
 56GG+3v1ci1bwwY5g1qfr7COU7in2ZOxhEpHtdt08MDSDFB3But4ko8zYqywP4sxxrJFzIdq
 7Kv8a2FsLElJ3xG7jM260sWJfgZNI5fD0anbrzn9Pe1hShZY+4LXVJR/k3H01FkU9jWan0G/
 8vF04bVKng8ZUBBT/6OYoNQHzQ9z++h5ywgMTITy5EK+HhnOwU0EWBOWawEQALxzFFomZI1s
 4i0a6ZUn4eQ6Eh2vBTZnMR2vmgGGPZNZdd1Ww62VnpZamDKFddMAQySNuBG1ApgjlFcpX0kV
 zm8PCi8XvUo0O7LHPKUkOpPM1NJKE1E3n5KqVbcTIftdTu3E/87lwBfEWBHIC+2K6K4GwSLX
 AMZvFnwqkdyxm9v0UiMSg87Xtf2kXYnqkR5duFudMrY1Wb56UU22mpZmPZ3IUzjV7YTC9Oul
 DYjkWI+2IN+NS8DXvLW8Dv4ursCiP7TywkxaslVT8z1kqtTUFPjH10aThjsXB5y/uISlj7av
 EJEmj2Cbt14ps6YOdCT8QOzXcrrBbH2YtKp2PwA3G3hyEsCFdyal8/9h0IBgvRFNilcCxxzq
 3gVtrYljN1IcXmx87fbkV8uqNuk+FxR/dK1zgjsGPtuWg1Dj/TrcLst7S+5VdEq87MXahQAE
 O5qqPjsh3oqW2LtqfXGSQwp7+HRQxRyNdZBTOvhG0sys4GLlyKkqAR+5c6K3Qxh3YGuA77Qb
 1vGLwQPfGaUo3soUWVWRfBw8Ugn1ffFbZQnhAs2jwQy3CILhSkBgLSWtNEn80BL/PMAzsh27
 msvNMMwVj/M1R9qdk+PcuEJXvjqQA4x/F9ly/eLeiIvspILXQ5LodsITI1lBN2hQSbFFYECy
 a4KuPkYHPZ3uhcfB0+KroLRxABEBAAHCwXwEGAEIACYCGwwWIQRfOQnenLUAKXFGgcnH3qdC
 2Jya5QUCYXa52AUJEskk7QAKCRDH3qdC2Jya5awND/9d9YntR015FVdn910u++9v64fchT+m
 LqD+WL24hTUMOKUzAVxq+3MLN4XRIcig4vnLmZ2sZ7VXstsukBCNGdm8y7Y8V1tXqeor82IY
 aPzfFhcTtMWOvrb3/CbwxHWM0VRHWEjR7UXG0tKt2Sen0e9CviScU/mbPHAYsQDkkbkNFmaV
 KJjtiVlTaIwq/agLZUOTzvcdTYD5QujvfnrcqSaBdSn1+LH3af5T7lANU6L6kYMBKO+40vvk
 r5w5pyr1AmFU0LCckT2sNeXQwZ7jR8k/7n0OkK3/bNQMlLx3lukVZ1fjKrB79b6CJUpvTUfg
 9uxxRFUmO+cWAjd9vOHT1Y9pgTIAELucjmlmoiMSGpbhdE8HNesdtuTEgZotpT1Q2qY7KV5y
 46tK1tjphUw8Ln5dEJpNv6wFYFKpnKsiiHgWAaOuWkpHWScKfNHwdbXOw7kvIOrHV0euKhFa
 0j0S2Arb+WjjMSJQ7WpC9rzkq1kcpUtdWnKUC24WyZdZ1ZUX2dW2AAmTI1hFtHw42skGRCXO
 zOpdA5nOdOrGzIu0D9IQD4+npnpSIL5IW9pwZMkkgoD47pdeekzG/xmnvU7CF6iDBzwuG3CC
 FPtyZxmwRVoS/YeBgzoyEDTwUJDzNGrkkNKnaUbDpg4TLRSCUUhmDUguj0QCa4n8kYoaAw9S
 pNzsRQ==
In-Reply-To: <70bf4b499941a6b19c5f750f5c36afcd6ffd216f.1746821544.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/9/25 4:16 PM, Josh Poimboeuf wrote:
> The add_jump_destinations() logic is a bit weird and convoluted after
> being incrementally tweaked over the years.  Refactor it to hopefully be
> more logical and straightforward.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  tools/objtool/check.c               | 227 +++++++++++++---------------
>  tools/objtool/include/objtool/elf.h |   4 +-
>  2 files changed, 104 insertions(+), 127 deletions(-)
> 
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 66cbeebd16ea..e4ca5edf73ad 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -1439,9 +1439,14 @@ static void add_return_call(struct objtool_file *file, struct instruction *insn,
>  }
>  
>  static bool is_first_func_insn(struct objtool_file *file,
> -			       struct instruction *insn, struct symbol *sym)
> +			       struct instruction *insn)
>  {
> -	if (insn->offset == sym->offset)
> +	struct symbol *func = insn_func(insn);
> +
> +	if (!func)
> +		return false;
> +
> +	if (insn->offset == func->offset)
>  		return true;
>  
>  	/* Allow direct CALL/JMP past ENDBR */
> @@ -1449,52 +1454,32 @@ static bool is_first_func_insn(struct objtool_file *file,
>  		struct instruction *prev = prev_insn_same_sym(file, insn);
>  
>  		if (prev && prev->type == INSN_ENDBR &&
> -		    insn->offset == sym->offset + prev->len)
> +		    insn->offset == func->offset + prev->len)
>  			return true;
>  	}
>  
>  	return false;
>  }
>  
> -/*
> - * A sibling call is a tail-call to another symbol -- to differentiate from a
> - * recursive tail-call which is to the same symbol.
> - */
> -static bool jump_is_sibling_call(struct objtool_file *file,
> -				 struct instruction *from, struct instruction *to)
> -{
> -	struct symbol *fs = from->sym;
> -	struct symbol *ts = to->sym;
> -
> -	/* Not a sibling call if from/to a symbol hole */
> -	if (!fs || !ts)
> -		return false;
> -
> -	/* Not a sibling call if not targeting the start of a symbol. */
> -	if (!is_first_func_insn(file, to, ts))
> -		return false;
> -
> -	/* Disallow sibling calls into STT_NOTYPE */
> -	if (is_notype_sym(ts))
> -		return false;
> -
> -	/* Must not be self to be a sibling */
> -	return fs->pfunc != ts->pfunc;
> -}
> -
>  /*
>   * Find the destination instructions for all jumps.
>   */
>  static int add_jump_destinations(struct objtool_file *file)
>  {
> -	struct instruction *insn, *jump_dest;
> +	struct instruction *insn;
>  	struct reloc *reloc;
> -	struct section *dest_sec;
> -	unsigned long dest_off;
>  	int ret;
>  
>  	for_each_insn(file, insn) {
>  		struct symbol *func = insn_func(insn);
> +		struct instruction *dest_insn;
> +		struct section *dest_sec;
> +		struct symbol *dest_sym;
> +		unsigned long dest_off;
> +		bool dest_undef = false;
> +
> +		if (!is_static_jump(insn))
> +			continue;
>  
>  		if (insn->jump_dest) {
>  			/*
> @@ -1503,129 +1488,121 @@ static int add_jump_destinations(struct objtool_file *file)
>  			 */
>  			continue;
>  		}
> -		if (!is_static_jump(insn))
> -			continue;
>  
>  		reloc = insn_reloc(file, insn);
>  		if (!reloc) {
>  			dest_sec = insn->sec;
>  			dest_off = arch_jump_destination(insn);
> -		} else if (is_sec_sym(reloc->sym)) {
> +		} else if (is_undef_sym(reloc->sym)) {
> +			dest_sym = reloc->sym;
> +			dest_undef = true;
> +		} else {
>  			dest_sec = reloc->sym->sec;
> -			dest_off = arch_insn_adjusted_addend(insn, reloc);
> -		} else if (reloc->sym->retpoline_thunk) {
> +			dest_off = reloc->sym->sym.st_value +
> +				   arch_insn_adjusted_addend(insn, reloc);
> +		}
> +
> +		if (!dest_undef) {
> +			dest_insn = find_insn(file, dest_sec, dest_off);
> +			if (!dest_insn) {
> +				struct symbol *sym = find_symbol_by_offset(dest_sec, dest_off);
> +
> +				/*
> +				 * retbleed_untrain_ret() jumps to
> +				 * __x86_return_thunk(), but objtool can't find
> +				 * the thunk's starting RET instruction,
> +				 * because the RET is also in the middle of
> +				 * another instruction.  Objtool only knows
> +				 * about the outer instruction.
> +				 */
> +				if (sym && sym->embedded_insn) {
> +					add_return_call(file, insn, false);
> +					continue;
> +				}
> +
> +				/*
> +				 * GCOV/KCOV dead code can jump to the end of
> +				 * the function/section.
> +				 */
> +				if (file->ignore_unreachables && func &&
> +				    dest_sec == insn->sec &&
> +				    dest_off == func->offset + func->len)
> +					continue;
> +
> +				ERROR_INSN(insn, "can't find jump dest instruction at %s+0x%lx",
> +					  dest_sec->name, dest_off);
> +				return -1;
> +			}
> +
> +			dest_sym = dest_insn->sym;
> +			if (!dest_sym)
> +				goto set_jump_dest;
> +		}
> +
> +		if (dest_sym->retpoline_thunk) {
>  			ret = add_retpoline_call(file, insn);
>  			if (ret)
>  				return ret;
>  			continue;
> -		} else if (reloc->sym->return_thunk) {
> +		}
> +
> +		if (dest_sym->return_thunk) {
>  			add_return_call(file, insn, true);
>  			continue;
> -		} else if (func) {
> -			/*
> -			 * External sibling call or internal sibling call with
> -			 * STT_FUNC reloc.
> -			 */
> -			ret = add_call_dest(file, insn, reloc->sym, true);
> -			if (ret)
> -				return ret;
> -			continue;
> -		} else if (reloc->sym->sec->idx) {
> -			dest_sec = reloc->sym->sec;
> -			dest_off = reloc->sym->sym.st_value +
> -				   arch_dest_reloc_offset(reloc_addend(reloc));

Way back in ("[PATCH v2 18/62] objtool: Fix x86 addend calculation"),
arch_dest_reloc_offset() was replaced with arch_insn_adjusted_addend(),
so I think that patch missed this callsite and breaks bisectability.

-- 
Joe


