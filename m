Return-Path: <live-patching+bounces-1499-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A98AD0935
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 22:58:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8455A7A316D
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 20:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8FE2185A0;
	Fri,  6 Jun 2025 20:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WxLMu6f9"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C4A21420A
	for <live-patching@vger.kernel.org>; Fri,  6 Jun 2025 20:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749243521; cv=none; b=WR9SJO7Be5URsWCXpG5hR5x2bToOiF3pVmhLTthRtMTpB4olFkmu8tfdLgd3ckPoLQZam8HVzEXKS67mTECbMjpReyuFKAwy5cFIui5nrfl3bHws5qTQEr/ET5xfZJnBQyYGl/d/QJsi/6VJR+STob9ajZeTxaAht8q/zwtnQyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749243521; c=relaxed/simple;
	bh=5OYc0uKWh7qIH+AR3SuReSyysjjqrsA/cCLLRH7dsAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vw0ayXhTt6YCvAb0jpjl7BqC44cu8XRW1p9p2MTcQtSviDrSbYAKejgcnrjxDkpzDTWu2HY5eGCouB8+Qvgh94StbDTIl7x+Q/52xcCLwGOYUj1ddKQH6NDTlS4MTTy6pxr+5Xo2Ri6+ZYVIhKCsryMWpprj1B30mfa8qb5wJRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WxLMu6f9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749243518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=guFPgH4oWq6xee/Rhvz3IuDEY33ZRCSZGOY5KIimvlE=;
	b=WxLMu6f9njRO0EFjti8p73aL62zW6xElpNUjpoVFiDCCpCY5ZyPiDd2d+rZNU1ok4AXwlH
	oj7FQ96q/4tfcBjKbE2WWT6Gak4eocuQG4y3n5wijuCNpBdZ5/+towlaX8M6XBKD0LqaHd
	CNzgA1wwmG9uUKPqOz7dP/+svmFaBC4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-nXudO5y8MAGghSUfvG-ydg-1; Fri, 06 Jun 2025 16:58:37 -0400
X-MC-Unique: nXudO5y8MAGghSUfvG-ydg-1
X-Mimecast-MFC-AGG-ID: nXudO5y8MAGghSUfvG-ydg_1749243517
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6fafc5092daso43867546d6.1
        for <live-patching@vger.kernel.org>; Fri, 06 Jun 2025 13:58:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749243517; x=1749848317;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=guFPgH4oWq6xee/Rhvz3IuDEY33ZRCSZGOY5KIimvlE=;
        b=ZNey1WKcbGsGtiKfERic77oggoZeTRCSL7YDMM1OIdKkREktb5/mRedUSTKoMGkd6K
         dlpxtcURuHuwDgTY90LZA7g4mBjCgY11zkeTMEu7S+xC171Oq7hvLa09FyN30PHOpKQd
         7o4Xm9XFWu669tZx9uUo5Z9xsTUvuIVUs1UAz1ggRLMhJpLngL0s+jjol3DrJ721KurE
         2M5jEsU68pOTGPmWe3qQFF8zw8yk94w+wQ1cp+qyrE8s3g+5/hAgjamlhI+GZurxm9r0
         0jCSMUNeHOWw42GMuSRy/FCfXrzV+g+4ClGWIF7q8i7J6ZoBmj2w7fGCpNRLQH+8RktA
         HcNA==
X-Forwarded-Encrypted: i=1; AJvYcCWb+nZhTY/YrK+G758ME63EqM+UlQcS+qElT/x/9v3QVs0hchJrv9LdPoK5qK8om440rpfanskTwUJl/Lyi@vger.kernel.org
X-Gm-Message-State: AOJu0Yxty36cb+R2/7E/J8dyOa8yQb/0898hFTvBQvATpCk07L0z8Fb5
	uG5M1Jx6sEKNOhm4PQLiE25GDipGK5u34/iOO/fErzO5MAokRcEQIdQKR7CzPlgDtXTZ/xfwK69
	RloqI1+LOiH7jOFOnqLxuFFC8hk7NFhTm3ma4Bg3pybpJLTwLMQzzu0AmjuNK/s21xmE=
X-Gm-Gg: ASbGncstrFEvLIYD8ktFtG2Bfy8t6yRrw19YvIOiYVBaquTUHZkTBJ8/2YiSCEFT0nu
	QWrAZoE1iauw3xvlTOo9dOnD88D5T28enkAZ2v61BMlg/BGvYxCAvNvrGLToYp1a27r4V/6v3kH
	UzwKDPIoo4eFKVocj8/OMC50afsSxt13/eIRsTPWEiblXEc2xVKd3cAxqMTGDrvQ+SHBEiWlRXb
	GL4Y7XyZT2hU97xn6QWnNag07awcxocEV0Ek2/psK11s+fuFOcy4E2U9VoZ4YynlES5N6vuk/EH
	5efBhqwpsUKCVyDtA7tIlO8Z0bDLiLYzOW8jJkaa7saG2bxZBepFDmFFkaMsOKzkFOU=
X-Received: by 2002:a05:6214:2022:b0:6f5:4dfa:6944 with SMTP id 6a1803df08f44-6fb0921374emr76184936d6.3.1749243517212;
        Fri, 06 Jun 2025 13:58:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHhGy1oMHsZOqoKexnPlR5OGbVbT9nbo3hIS4Q241Y/MmfB4nAGvYTMd0FKz6d+fiBye1h5YA==
X-Received: by 2002:a05:6214:2022:b0:6f5:4dfa:6944 with SMTP id 6a1803df08f44-6fb0921374emr76184716d6.3.1749243516943;
        Fri, 06 Jun 2025 13:58:36 -0700 (PDT)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb09add2easm16922886d6.51.2025.06.06.13.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 13:58:36 -0700 (PDT)
Message-ID: <07252044-070f-405e-b1fe-ea27da7746e6@redhat.com>
Date: Fri, 6 Jun 2025 16:58:35 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
 Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
 Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>,
 Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>,
 Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
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
In-Reply-To: <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/9/25 4:17 PM, Josh Poimboeuf wrote:
> +copy_patched_objects() {
> +	local found
> +	local files=()
> +	local opts=()
> +
> +	rm -rf "$PATCHED_DIR"
> +	mkdir -p "$PATCHED_DIR"
> +
> +	# Note this doesn't work with some configs, thus the 'cmp' below.
> +	opts=("-newer")
> +	opts+=("$TIMESTAMP")
> +
> +	find_objects "${opts[@]}" | mapfile -t files
> +
> +	xtrace_save "processing all objects"
> +	for _file in "${files[@]}"; do
> +		local rel_file="${_file/.ko/.o}"
> +		local file="$OBJ/$rel_file"
> +		local orig_file="$ORIG_DIR/$rel_file"
> +		local patched_file="$PATCHED_DIR/$rel_file"
> +
> +		[[ ! -f "$file" ]] && die "missing $(basename "$file") for $_file"
> +
> +		cmp -s "$orig_file" "$file" && continue
> +
> +		mkdir -p "$(dirname "$patched_file")"
> +		cp -f "$file" "$patched_file"
> +		found=1
> +	done
> +	xtrace_restore
> +
> +	[[ -n "$found" ]] || die "no changes detected"
> +

Minor nit here, I gave it a patch for files that didn't compile and
because because files() was presumably empty:

  ./scripts/livepatch/klp-build: line 564: found: unbound variable

since found was only declared local, but never set inside the loop.

-- 
Joe


