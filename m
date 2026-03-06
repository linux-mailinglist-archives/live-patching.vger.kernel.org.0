Return-Path: <live-patching+bounces-2148-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kDU2Ij/cqmkZXwEAu9opvQ
	(envelope-from <live-patching+bounces-2148-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 14:53:03 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2683E22224B
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 14:53:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 411A63091F90
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2026 13:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8804C39F194;
	Fri,  6 Mar 2026 13:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VR3PDYyw"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC854285066
	for <live-patching@vger.kernel.org>; Fri,  6 Mar 2026 13:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772804749; cv=none; b=hzHeIw4GGxNkGTt61c0JdEhAlJLQUAQTsUSgVbwiRCLGdw6QTjhfOUHLOcai7zARYW3qcppsaULbaRZYP4fGo/rWS2VvgwpuxJmBAMAYOqtjMct8NkK801osuDUMeg6TIbkqiTzWpY07sqEo6D4f8FTx+ZMr4/OvwkYuzp1GL8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772804749; c=relaxed/simple;
	bh=IZcCd046q2xhrrrrEWiiXgi3zY/ph1FdsWl/I7S37Qw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d2c7wkgERI+zFHVpoUIv0Rh5jNZnwAFDBGKcTlXmFxs4KbvhpeRTsM73R9mlkBrU179QWOOKxIfOHDuI405DiJVhepIw1Gm07pirBtspiLr8UuLVRzaFU3aWh7Uk45ofTVoLaO3MHrZVxZIgFk4WdC+QvhoQjh35q1Tlm1VpEVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VR3PDYyw; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-439c9eb5d36so2798865f8f.2
        for <live-patching@vger.kernel.org>; Fri, 06 Mar 2026 05:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772804742; x=1773409542; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OV6EE6RoCxw1rbG3/V3MYG74ysZnRV2qqRKRpT6tbsg=;
        b=VR3PDYywMouetVyqIQS3SP3yf18vjdDYJO1kbIO8mVu534I5xPTqgPUyHS5KdoTuet
         R2TilY2To17mpUcOiblicJ0iPIt5ojNsr/1D2lfGsGZFPHSLELt5z+vLxZnUte0pRc1f
         Mzh9PSaAiRM7P/ugWPwXQ834Dw9ZHezI1i75hAWnbnON6ihB8kp9EDUQiomyTEUgW3WL
         EaNp2Lc6SyKests2xQkC0d6PVJm/Q2s2Gb3zMfaLRNxPbvAL9g/bsN7PnuR01ggTEOra
         EPW9HGubz2S6j/XDKXEnkm8q2eTFqsdA71FlORyAuC3yneqbyHbJQO1ri0KjFThqioyI
         dnBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772804742; x=1773409542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OV6EE6RoCxw1rbG3/V3MYG74ysZnRV2qqRKRpT6tbsg=;
        b=FhbKKhz5g4OfO0QbyRm4v7XPPvkjPTMgPj4hown+/PRonF+HgZ5WzMJnZDlSHpD7zu
         0avpZUqV4GHXlvQsC8YXlaiAicZGT0VPqEyEuEtvU1CCRmJFzOYbU9u7AevOU+Lwpr9g
         2KP+rarlwrrqUlRQjIsdn/8DxSZIbIKpNjDsLmt26RPKwTJwAUaLqVl2cy/KQiTRHmiz
         fwGdsnUqu/3UCpE4r/t7xpjJ7cEBvEP1aU5DTfWBDwntVbLTWH1meMunZKSkq5zRlGQC
         2Yf1zO9K0UqfPCO3nDiExzn+K5snL5I2w2uc/DCkztGWLEpFl7tyZKy+PnX6KFl+ShvJ
         +/CA==
X-Forwarded-Encrypted: i=1; AJvYcCVrLTMNdjKrPZcvw9BM0gY/Qd/N7qDJ1vfwkAb/R2VYKJ69+orh75YwWwJ8HsFI7ON9NXO5vsuMYu6foPMc@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7534ZtoOhaQ1jjPgjW7b3ekHd6cfCLzRaOKsECi8XCHIv2uGS
	STeEml52/efb2Ywf9MZriTVdBZ/Cy4+qDOm2uWGYuJeXEGCYooQ2DZy0czKAWZLmbuI=
X-Gm-Gg: ATEYQzya7uZjUfZPdS65Reo0x/4Mz+348hl55b3OZOcnO+HyJP2yRNLO1Fq/w/iqrIS
	UbMtgWwVRUr3jt5bT0qRybo4RFxFt072wVT9CtMkJMkE6vdUvUeMLhpfnOKAABAZGmviSou9kxx
	62f/HCgrDHY7ddrsaBx6En0UbfvJtnu99tdaCLV1kAbcC8OS9JU5k0OS5eVd5ne97JMG28kC14/
	PKJq0TN9nKjY/XJHyBn6VT3crNDGuRo2bavqrNjdWdqaCc3Z7wQ75q0y+r8VidVNdg2MGSuXVnf
	GE2YUC66I8C4R4XVT9LbIc8S0Jjoxo+vt+JKERXl5UpYxJ8miVzawdkOY601Ol60gjgtuQUsfhc
	gLUSgSnREMACHRavYeFZ+j4GSVhqnxwij3BX8vmomZvyXPhCONHR3wjVE0FSqeAV2kycx3EU7T2
	xmQS0sx3W00xt547uI186FGCsMlvm/L20i9bDL
X-Received: by 2002:a05:6000:3112:b0:439:b79d:b9a5 with SMTP id ffacd0b85a97d-439da35f63fmr3688028f8f.37.1772804741726;
        Fri, 06 Mar 2026 05:45:41 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dadb29fdsm4191867f8f.16.2026.03.06.05.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 05:45:41 -0800 (PST)
Date: Fri, 6 Mar 2026 14:45:39 +0100
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] selftests: livepatch: test-ftrace: livepatch a
 traced function
Message-ID: <aarag5K43WElzDqT@pathway.suse.cz>
References: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
 <20260220-lp-test-trace-v1-1-4b6703cd01a6@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220-lp-test-trace-v1-1-4b6703cd01a6@suse.com>
X-Rspamd-Queue-Id: 2683E22224B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2148-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pathway.suse.cz:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.com:dkim,suse.com:email]
X-Rspamd-Action: no action

On Fri 2026-02-20 11:12:33, Marcos Paulo de Souza wrote:
> This is basically the inverse case of commit 474eecc882ae
> ("selftests: livepatch: test if ftrace can trace a livepatched function")
> but ensuring that livepatch would work on a traced function.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

Looks and works fine to me:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

PS: I am going to fix the typo mentioned by Joe and push this patch.

