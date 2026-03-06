Return-Path: <live-patching+bounces-2146-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UL6wCdGaqmmbUQEAu9opvQ
	(envelope-from <live-patching+bounces-2146-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 10:13:53 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E0C21DB0F
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 10:13:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CA511300C544
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2026 09:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD60D3164AA;
	Fri,  6 Mar 2026 09:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gvy/nJq3"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321BC2D5924
	for <live-patching@vger.kernel.org>; Fri,  6 Mar 2026 09:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772788426; cv=none; b=L/2wFPYyFZ63/W7ULIl9DlsRjFcxnktquRi7yA9vzZoJEdaxpkAvTKjCgfXp2cBDyGyNLRi+53JVcqodZyX3FtkvVETr5HUJdC5baWsmX26ViTtLAwpSA6BSgNwTzXrkG5AKN12Uoe+rLPtn2BKoGrs7W6oFQZKjsJdsZb0w+kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772788426; c=relaxed/simple;
	bh=JP9ayxkR70+C5x4/kqauaA9VrsME7NsTNfpAZzrk9eU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMewV8lkzgSJk7w97z9dHXmLjUlwWdCLK3ny71EvFS/9TXlxKRxEOfvNgaSmMQXTfQ1uAHKjhIibjTZ379ciDLqUwOUXnjkgIKciU/6ahTXtjsFJ4K5+YQE5PDLgD2CmJw7JNDpjz1yzHlT8ciaVB2MivLxMfQlG/Q7ZwXQ9W8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gvy/nJq3; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-439afc58ac7so6020701f8f.0
        for <live-patching@vger.kernel.org>; Fri, 06 Mar 2026 01:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772788423; x=1773393223; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pHFHSQMSInOJ9dp27FHB8xneKsrVu95gfQWlnHhZ8aE=;
        b=gvy/nJq3zBjqvjrreSjBGLVxjQDbKdh8TOCLU2BawRk3f7yeoMmGjSZPUpMZKfPSc1
         gSXVYwCaW6NAGaKrGU5VYBUKWNJirVXVfy0TDoefzxNBZYcnfoyI+MD7Izqqe2x1trkJ
         yUU5AL1H5r12Bo3ZXq/6QsdmGwF40836I/bBq8lMkG5tNv7yTd0PvZVIWZkJ7UE479I1
         Ukq/gxplrpYn+nGwGNgmwb0vWVN0giTm0CBhSzsdnAm2PoUN5k52PeV8s0xOU55zThGO
         +YraNWqjy8GIEkpLr74TP9+n5g/YSJ9goS7MaBZScU3JWVNzswrv0nFmOJ/FNyBH5QrL
         3Icw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772788423; x=1773393223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pHFHSQMSInOJ9dp27FHB8xneKsrVu95gfQWlnHhZ8aE=;
        b=qDhB13PFsm790WCPhNgKFCY45VtrYq8qGhxkPQNXbrZzoFvHoFRWK6kkJjrGUgeHr/
         j9Z5qTsMvjzeW5MJy4Cy07zbmj1/rpcCKDnYKKIy81zH677bBcC5UHu0K7+jWXD6ZZCi
         Jb3phijbhQvrCKrCBSVb2evZP16IBOjwSZfEuulol+SYJi7M+ENT6Gr3w4mssYYd/6a+
         yGPMm5ijLTtfUZ8BeRRf0FKWN/A7uc8APWmOHdzGstrf8e2PEZPHNo/pDleHDamDw2yo
         kaSe1aCbtMpLzUrsVWsHP54HieFfwauUUTfg+lSmPe/My1mJKJ4tHMQNUJuXzWb4DEMx
         ImpA==
X-Forwarded-Encrypted: i=1; AJvYcCUoVJQYLy2SpRpvrTXOCNR39n0Hyk7NbmZMN69hCtHPgE1WBbIr6mKBBlloCQbste8soRZV+ZbSXmJSPW7M@vger.kernel.org
X-Gm-Message-State: AOJu0YyMibI1B+x91XO9p90Z56wtmOm4n+q9TrH4RhC5uvmyprD5Caad
	9joU6YLbQnKlTWjdmEq7/t9QHRGcAqI51dc2myG1PrEr7tvq45FFmlTJM/ML1PiR69I=
X-Gm-Gg: ATEYQzze3ut3wK18LsraXbN+jeNuGd9KTMZMMIPM8oDxiAfFYJT7zAUkYNXANOCzGWV
	wgg2+tU74HYhIVZThwdRLbXs4kupMkkRsAOEQjs1GAKsrwjcHKr2ORuPhp8Fg1cB7ZXE9igtnW8
	V+Evko9eXA4H1eegiLRPRbFy+FIaKtWU8jf4OTcrEkS0Zr7vB4s0ZiCw5MJ4Ds1SLb0yBnKQbHa
	f2dykZxQ6thH7DbFziK83tYv0KAHAmjcj/duSoYrFYsCeeY+LhI0sXQAkofHnbPS5Nvv/uhEFKX
	5H3DZHn+Wi2hez7izG8HWS3TU4mGkS9In8vZhVxgjEN4DsdeAEv+r/GSa0QyJRn/qQXryT0mVLH
	9DEEO2JJSy/3YMPZFcfoUiFwAcP84unitysIqAS0ewppUW5HjPqNPzknpfuXBL3eWNpKiXtSwgi
	zXwVD4QIAlhfPClnwyjpnLDnaAIA==
X-Received: by 2002:a05:6000:2385:b0:439:b60a:b3ed with SMTP id ffacd0b85a97d-439da5552e5mr2089613f8f.9.1772788423424;
        Fri, 06 Mar 2026 01:13:43 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad8d973sm2261878f8f.3.2026.03.06.01.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 01:13:42 -0800 (PST)
Date: Fri, 6 Mar 2026 10:13:40 +0100
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>,
	Song Liu <song@kernel.org>, live-patching@vger.kernel.org,
	jikos@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
Message-ID: <aaqaxB-9MGgSo0I6@pathway.suse.cz>
References: <20260226005436.379303-1-song@kernel.org>
 <20260226005436.379303-9-song@kernel.org>
 <alpine.LSU.2.21.2602271052240.374@pobox.suse.cz>
 <CAPhsuW69EZTcMGyXSKv2fEjh7mhtYaSxriZrSgX0nTPCEYKS7A@mail.gmail.com>
 <alpine.LSU.2.21.2603020930540.21479@pobox.suse.cz>
 <aaiI7zv2JVgXZkPm@redhat.com>
 <i7i5tbrk5au3udsoigqzwhjwziiiylehaxhauz3pfgongk56hf@dz56fniz7w2a>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i7i5tbrk5au3udsoigqzwhjwziiiylehaxhauz3pfgongk56hf@dz56fniz7w2a>
X-Rspamd-Queue-Id: 14E0C21DB0F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2146-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,suse.com:dkim]
X-Rspamd-Action: no action

On Thu 2026-03-05 10:50:53, Josh Poimboeuf wrote:
> On Wed, Mar 04, 2026 at 02:33:03PM -0500, Joe Lawrence wrote:
> Thanks Song and Joe, these are some great ideas.  Testing will be
> extremely important for the success of klp-build.
> 
>   - I like Song's idea of adding a fake (yet stable) test component in vmlinux for which we can create .patch files to test

Yeah, it simplifies writing and maintaining the test cases.

Also it helps to isolate the tests at runtime. I mean that it might
help to integrate the tests into some higher level testing framework.
I always wondered whether changing some interface might confuse
monitoring or debug output on machines used by misc QA teams.

Best Regards,
Petr

