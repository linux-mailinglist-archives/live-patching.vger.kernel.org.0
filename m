Return-Path: <live-patching+bounces-2814-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OJOdCn7/BWrFdwIAu9opvQ
	(envelope-from <live-patching+bounces-2814-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 18:59:42 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A72545074
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 18:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1E39B3035B7A
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 16:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65810346E57;
	Thu, 14 May 2026 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GX9hqZP2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EXAzfhFD"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1147334688
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 16:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778777963; cv=none; b=qeIx7jX7Uo6AIJxY6qbvnSKjSVBDP8k17bUb2mb+pur7UYuOiCxAvtOPS113CcO73adESDoENQjKni/M4QOPgUK3LN4vzmQoVHGzPf3NZthmQaVLtCjQVmhjPUuu761H/NGJqWKGygVViwQ+1STAmcczwJEEKUfxmFfduVb5WMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778777963; c=relaxed/simple;
	bh=SkjsTzHypRNGGoTsaYvQJwnULy3oD1M86ujn69gmmFc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GjKkrSLCZkEur/Fj5PQRaw8/OvLyAIse97hn1GO/ExX1tSbft3LxtGko+wc5IU6ZX/z99VlJfk0swzPFbCZPR4TfyO5LJQwa4K38uX0IosGJrE2rdpfjbWcPsZlIItps9cbnnxqBJ7eJA9Ldc/2jtEzsKklYrUDzUvYZ/6rNKBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GX9hqZP2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EXAzfhFD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778777960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FhNCQ8gp7TslONMbGbp2x40uvfZu19Q8zPJhcFVbEOQ=;
	b=GX9hqZP2SxxFarfJ91NtgalbJu5JKeQb0jzDBb5t9PforQ2LUVk6IUeizWy2hRLi7T0+gi
	ilzVTQmKgbVN18ZKY5qr2wlg2GSCDf2DtvR9I1vvGCkxEgxLS+dCC+F4lisEgz2w5I4CLM
	M+LWvVYPPnNI4bk1o7zQxr148M8uwYc=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-NP5wLfHsNDqIrK8ZsvHyVA-1; Thu, 14 May 2026 12:59:17 -0400
X-MC-Unique: NP5wLfHsNDqIrK8ZsvHyVA-1
X-Mimecast-MFC-AGG-ID: NP5wLfHsNDqIrK8ZsvHyVA_1778777957
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-65d8d110fe4so286160d50.0
        for <live-patching@vger.kernel.org>; Thu, 14 May 2026 09:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778777956; x=1779382756; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FhNCQ8gp7TslONMbGbp2x40uvfZu19Q8zPJhcFVbEOQ=;
        b=EXAzfhFD6HGMobRb7Sq8WL+osesyB7L9VzdwUS/rrtfS8CY6BDZ1Xm/NI7ICOzJroZ
         X05Zx/F26tl0n9yYNXTXQ9J7smubH61bSvd1LWh2lGAMpQ76JzN7QevctpnvHR3C29ZH
         uZuY/KbWTjPOcQ/CXHQlcf1g89FOgrs9vy3uO0lG+rIRoWJyBmfqVQJVPPcsn3If9jMJ
         cPNbHtEIljOaBgPlASbTeDxShlv7VgpZw+lQK+EKj/ZjbvWFZHXlh9jS8BUzy8C+Y9iu
         CIrP6Z3lU3WRMtuBbql0FdHD1/9/YsZEyFbYjL6v398A7Kq8BCPp/HgprfzRFf+mMG/b
         FQrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778777956; x=1779382756;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FhNCQ8gp7TslONMbGbp2x40uvfZu19Q8zPJhcFVbEOQ=;
        b=bWfCbgz96GlUj0sgHBddgylMOYHdbeidjkxCZaPCG9vgC6iwkuP937ZLYdimehQP5F
         E9eGcAvbhq3WCL0P2ZbEYmUTvxesfiRW4GUW0SNvi0cmukxss5uStK4wLqbKbwy+FE1b
         PUfTvlkv0baHZotocOm7Ne+3lOzZEj8JiGqMuyrGjHQkz//77GePrCgysyCLP8MWrZfE
         1Ix39Hr7UkAldxwFdf1ECwwgxM2/n/TrS7n+LXUXI/2ksU79K8hcCvS8jy4HO50SmuoW
         QqwmEun/HPn2/Laft1tn8TUwP7Y8ttFIhnAqZfW/q8rFxELa4gZFrx6MRwvX82RjWwXr
         V5Dw==
X-Gm-Message-State: AOJu0YwsNOvl7PR34/URCHpnA8umBi6/+8iFCqp2C2HcvENUsTIejlQr
	OCvGwD//aQ1iCeX9zekhqveBG7XPCDHUwf8zrrFYXCmThv8Fx+HsqUXHA8GU3j/WZNoHaqe0fVq
	fac7jr/7AHXRJOQNeW1UL1TX3cc/Yy7yp9jhcGCNEyChn2aE5PTUFzwO2mh4D2dd+hPNhIqkCQs
	AqoWG8ydt9zlomtbYV1OUK9xa2Lbx13ll3W/udjcgKrfhf//nv1JlahEfd
X-Gm-Gg: Acq92OHRDvaxcCs6KSGozVTtO89hwEROm+3rZKyLRleumGXq7v1ipZ6HKsUZx4Yuphx
	+92oNlhzPI3ZCu8eUgMgUnJEq9wE7Hrmx611UgwZMVhQDAhwh9WBYpxhXY4Y+cynZ/U73aSGQXc
	FclUU7AmOAvqL+LkKXwOMqUDJlB1LNJcnTUl9J9Gc1nlAYLx9qCWw1WC08+7eD6YUXNEFK/hR8m
	86cw+FhpD5gvmoH+8E7s5Ij7LYSgcJRozsIWCYqI+o+z6Ybg3pkOpj9JRev515MrwyQk8HQ2m69
	Am40LwZTRtPoMn56ejWrocKfy1GzCq9ciK5F8fOH54SDRrbvVV5Q1X2vs5lwnayjEgrOUJuyom3
	gWnOWPqmbCbbPDTEdCJ0PFqxHCKLTJeAqu9s7yjOPZ3aMgZv+68/G2SPsZtVKu3qozMqtFlqmGG
	aydg==
X-Received: by 2002:a05:690c:c4c6:b0:7bf:b4a:179b with SMTP id 00721157ae682-7c7e7e1c37amr37779317b3.18.1778777956483;
        Thu, 14 May 2026 09:59:16 -0700 (PDT)
X-Received: by 2002:a05:690c:c4c6:b0:7bf:b4a:179b with SMTP id 00721157ae682-7c7e7e1c37amr37778807b3.18.1778777955818;
        Thu, 14 May 2026 09:59:15 -0700 (PDT)
Received: from [192.168.1.26] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f2ba91acsm16895637b3.19.2026.05.14.09.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 09:59:15 -0700 (PDT)
Message-ID: <acf584ae-dba2-4306-89c4-da9ed89a45da@redhat.com>
Date: Thu, 14 May 2026 12:59:13 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Sashiko patch review for live-patching?
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Jiri Kosina <jikos@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
 Song Liu <song@kernel.org>
References: <agSjM8dxgnV9QQaf@redhat.com>
Content-Language: en-US
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <agSjM8dxgnV9QQaf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 76A72545074
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	SUBJECT_ENDS_QUESTION(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2814-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/13/26 12:13 PM, Joe Lawrence wrote:
> Hello live-patching maintainers,
> 
> I've noticed several references to the Sashiko (https://sashiko.dev/)
> kernel review bot on this list and was wondering if there is interest in
> adding live-patching to the mailing lists Sashiko tracks.
> 
> Integration appears straightforward: we can submit an MR to add our
> entry to sashiko-k8s.yaml and customize the bot's email behavior in
> email_policy.toml.
> 
> Full Sashiko Maintainer documentation is available here:
> https://github.com/sashiko-dev/sashiko/blob/main/MAINTAINERS_GUIDE.md
> 
> Personally, I would vote to set reply_to_author.  I don't have a strong
> opinion on the other custom options, provided that the CC list is opt-in
> rather than simply mirrored from the MAINTAINERS::LIVE PATCHING file.
> Either way, I've found the Sashiko web interface very helpful in patch
> review.
> 

Sashiko.dev MR for live-patching@vger.kernel.org w/reply-all policy:
https://github.com/sashiko-dev/sashiko/pull/195

-- 
Joe


