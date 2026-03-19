Return-Path: <live-patching+bounces-2239-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GP1fK5AHvGkArgIAu9opvQ
	(envelope-from <live-patching+bounces-2239-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 15:26:24 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C0BC42CCC2D
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 15:26:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BC04A30770FD
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 14:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B5D339872;
	Thu, 19 Mar 2026 14:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SYogBfC6"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1198C332911
	for <live-patching@vger.kernel.org>; Thu, 19 Mar 2026 14:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773929809; cv=none; b=r5JWa7++J6NIkWyP4o9so+JEv7tjJGifMaLvZTdMyJnPsGHvPWXx9G4J1+oxy5dSTaxzrzKgq/k7xJ2TXSiz6dSIRcUQ5eEve7B8xQk9P1ZbGuMIyX+WrXob43q3wtc2f73wMkWZDZ1hb+bqm5giROUFcV7ux8GJdnt7blN17A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773929809; c=relaxed/simple;
	bh=oH1bdQsge78AZnJ8U2ypTSnHGZ7af4myhSHPghPP1L0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z2ZqfydpUWXEegCDtdEsyjlnsCHR+PinNy3tdzDvlA9J0TR9+VwPw7DoJHd7DJA1kKOVTpVUhnLC5O82j/YYIam+/unc29VhAQIH/NvjA2qnrf3Mc/vOxMJMkTQLunU5dMPPF9yzxywBvzN8uyp5tkyBHL4UgA58+6bzDkQ9C30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SYogBfC6; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-439b2965d4bso741742f8f.2
        for <live-patching@vger.kernel.org>; Thu, 19 Mar 2026 07:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773929802; x=1774534602; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oH1bdQsge78AZnJ8U2ypTSnHGZ7af4myhSHPghPP1L0=;
        b=SYogBfC6IP4+wBbk4zmL5TZx8YBIv2InZUqxoMD1eulf9Ht43z+aKEmwy68DeKBdmv
         uaIguj1MMQhCOSUuNREx80QexQ3vQnti0tX8vWPK8GZDQBPEz4mWua/xorj0IKJ07PQt
         E86nHqdbHhzfuAs4yhWfwGUA1SAz1n9dlV3JHeWJENuK5+Jh3FoqiyWpxK3HK2j7FZfj
         vh9Z8jYHLU/J56erWkG5pNzq0P3NlI+cMx88euWiXhawLotVgdv2blLAWUN1rAw1LsXb
         vU4XRe7uafaD4rTqqGKCiHXw+PmhJYvHeWb9hC2etz2k1J/v13u+Tm3of61Wnjx4zW5S
         9R6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773929802; x=1774534602;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oH1bdQsge78AZnJ8U2ypTSnHGZ7af4myhSHPghPP1L0=;
        b=EWXGldVCXYtwOm9dTYIGQlCR3IfW26/eLW2DVoegrqO/ynzqRGgG53Zd2lzOKC1BLm
         qdaU3XTARVl17oYRYayyhVT8jaHBP+UPrKk3tVeeYpFffKc5KlmlOwV3oG8FMfxKclaX
         5Rk5S2YYojzuA9Hq0DjcOfpUXqbfo83n9ap8HyU3EybGrcGqwNj6+2tRWCAkjnm74s8U
         9+4omLv8ejvo1iqcVncJaZBlkIfyJUPznYIsHQ1Xe89Hf8raalEp3PTV9ZTvgZlzoWDl
         3WsL2RXlWNm1xWIp+Xi9qY3Cxuoa63jVAUG2PXOQDMupBNRskMYBMRpJaWC83CZKwvTb
         UvOg==
X-Forwarded-Encrypted: i=1; AJvYcCV88SNDJqVGz2wvJJqh6xbdo9IedSQVTCyzKdvG7mz6f9uTqQ3eN2ryGRiMVNeuiMhfV15Z54lsNgmdy5ml@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi/3raHfjCFNwqGkM/26dhApwQuzvTxBn/1IK28wkiJokOluiY
	pOKh3Wl/sX6FR/RHOdcBpBRkQ/WtKmRvKQ/gWbkoSkLx/I2YS9RBYW6zDcJdG7disf8=
X-Gm-Gg: ATEYQzxWXL82/c5cHOpQHJ7NpUaFISkSRkjzYTJl5iw2JG3yJh/9rIqrh3SI5KShDL7
	1QTUxdhluOsUZ18EDahSSo+hrSkvTmXRul7ANQ3M98nwrb42pagDTz8CRivPzD2CQrXwuRRpWMB
	9C/6BRALqvOtp+f0IV+XEYkbVbLxRg6be8H6Nj6BpYesxMjPyr9eU7hjOjqbvkbK1Nfot2jx/+N
	0703Xhzsv4jOvHw7u/UXMz+nA2pgGpIEqVXLUlQM+NfYORV4RryZ1JWpO+bnoz6EKXNXEAhC2HP
	NYcYhi9ZPSXH9JAiyqKrY9agPJLUMQch6mpBSTe/VNF3xMQ9R8k6z+ns6NC8D7BpMFZZ80Sa1Ry
	JqosHKwyB4twh6XBTVdbtk2q+8KzV6NGDYpjA93EmT+JOnWLpUj7XxnCU7ijzOeVzt5M10CN23p
	5BgLoxJWlXqJkcqsFyqD2kYm8XIHlvNloH7a3LDD5MlyZ3olGmX+oG6Z9q2zjlzNuaFA4fcn5D
X-Received: by 2002:a05:6000:2483:b0:43b:4469:d31b with SMTP id ffacd0b85a97d-43b527aa3afmr13023574f8f.15.1773929802286;
        Thu, 19 Mar 2026 07:16:42 -0700 (PDT)
Received: from ?IPv6:2804:5078:834:1300:58f2:fc97:371f:3? ([2804:5078:834:1300:58f2:fc97:371f:3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b51851e43sm16852370f8f.10.2026.03.19.07.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 07:16:41 -0700 (PDT)
Message-ID: <a57eb2eb73eb8bd817196b8505ab59d5c3bc187b.camel@suse.com>
Subject: Re: [PATCH 2/8] selftests: livepatch: test-kprobe: Replace
 true/false mod param by 1/0
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>,
 Shuah Khan <shuah@kernel.org>, 	live-patching@vger.kernel.org,
 linux-kselftest@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Thu, 19 Mar 2026 11:16:36 -0300
In-Reply-To: <alpine.LSU.2.21.2603191401380.22987@pobox.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
	 <20260313-lp-tests-old-fixes-v1-2-71ac6dfb3253@suse.com>
	 <alpine.LSU.2.21.2603191401380.22987@pobox.suse.cz>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2239-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: C0BC42CCC2D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, 2026-03-19 at 14:03 +0100, Miroslav Benes wrote:
> A nit but I think that "test-kprobe: " is unnecessary noise in the
> subject=20
> and can be dropped. It applies to all patches in the series.

Ok, I'll drop it in the v2.

>=20
> On Fri, 13 Mar 2026, Marcos Paulo de Souza wrote:
>=20
> > Older kernels don't support true/false for boolean module
> > parameters
> > because they lack commit 0d6ea3ac94ca
> > ("lib/kstrtox.c: add "false"/"true" support to kstrtobool()").
> > Replace
> > true/false by 1/0 so the test module can be loaded on older
> > kernels.
> >=20
> > No functional changes.
>=20
> We also define a bool module parameter in=20
> test_modules/test_klp_callbacks_busy.c. Does it have a similar
> problem?

No, because n/N was accepted as false already on 4.12 (SLE12-SP5). I'm
not sure about older versions tough.

>=20
> Miroslav

