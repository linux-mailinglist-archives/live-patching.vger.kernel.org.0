Return-Path: <live-patching+bounces-2368-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qBC8F1744GnZnwAAu9opvQ
	(envelope-from <live-patching+bounces-2368-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 16:55:26 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C1DE540FEB9
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 16:55:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8DDC23050C0D
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 14:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F403E1CEE;
	Thu, 16 Apr 2026 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AxvLgQs0"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A1B3E120D
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776351269; cv=none; b=gLSG3qb/fFEANFPN14Ejtnv4TnSs1DrbAnMpoCbD1k7t+QR3fSicnt4M330w5xIGeOeY8Dg2YJbK78KUFI90TCq3kruH2JAZYDWK2ElodE3fDLtHxjStGLwN95LpIE8CzKiC50gdqkuURSHzutyXDQHFgRQ+Pw92BEb2irdvX1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776351269; c=relaxed/simple;
	bh=EPHRfB7I5uH7xIWit20L1zYnCi9wOT2o59aqll9Yfh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CMvcPZ6nLj2e2wxPPY91GdfYFCNCFxSwiUuITuBgl9FdkJzaWs3dQ2Ay12E6c//3QZWB0J6XuVR3dvCQaK0uR0w+09pJW7K/Dw1iN10ISH8C1qIgN/EAOBnG3p83BMA7PsmsUnsHBmM1iLjnwNHXPyciZubr8iq6aReIUA3xon0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AxvLgQs0; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488c21c636dso49836985e9.2
        for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 07:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776351266; x=1776956066; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nUk9+5ugjhG90uPs8bskXfY1v/H6BYvalTyZQcNSMUA=;
        b=AxvLgQs0aTfo5aAuCATMtxqRRyrWZscAlPsA/t41RJ+9AHIVNMbCmUsIeVQrkPCx+c
         w6usVFoGLtuyL6ix3ExuPLMCE2wXopuILo7/owj/aeMHFfikW3URlwtyVLrBFDMGmC9R
         oriTluTZb8rpNneBcFfL6C9opqoTySGkMuV66LC6WpwfOpNLO3JZwFkHqLleCS4QYWsv
         7xNDCB+p2+IISzNFUXDt5Pq74+TRIkbYatSvjOFQ/jusNKjpBs6kIWj/kmd646CZan1f
         vOyVERub8RMzJxxLAGz5S3gV5TaQz7ehlGQp3Jm1jNc58JUIwHLYqgbcY3wChskeG4uz
         ABXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776351266; x=1776956066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nUk9+5ugjhG90uPs8bskXfY1v/H6BYvalTyZQcNSMUA=;
        b=nfhuRhG44ysDC/Jk2s4Er00XSBysH9iVXO262EuRPizn+oomzA7PncXrX4Lw3M6QwC
         DnY6aCXtkdOjT6AnUJO0vM5DcY8LhurPsF14KKNO9EKPMXJONxyM3Zd+r6cr12oQK98y
         Lv5lObgcWc8YVUitRMZrPpOz1D5y5cF+vMT7UF0ylUWrkPr6RnSHFTJ2kHfPOrTDagjN
         PeCc0ZwP5MJ54jTVLModgvWseIohwdjEnbB0zOo+QtP+InlAzxhQ8/QgOCkqPEm2MAwT
         sej0uFiC8Jv0b42uq2HcNu6XG9JEvb5/6G79fYMYFxMVcJDL7FReSyUS43ugRy0AlfIg
         848g==
X-Forwarded-Encrypted: i=1; AFNElJ+BaULMhKAIU8KZJ3J+oF9nMjM7fPYq8axo7BKRKHcjnkg+R+03GLK8fTdyojoatJAiOiE1Aem5d5mOJKWS@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3uf2NH4ZINY9TWVnKQEXjrfr1s2Cf+2eMW6YCzQADoI0vvsrr
	qi8MIQh1zoPtL2AWzdABaotpJeSzPs/4pnHfODv1cZDjr2HK73kj39496HDPO8XVWIk=
X-Gm-Gg: AeBDieukbUoDBcvZPmnKisQf+beKViyvmY1KvSTsdfNpvqu6Hg7/rHf2dV22CdaM9D4
	GsIMzfBJ5n/o4qdOYceb/XECkcf2WJxiUm+7qXkpT4MjedW+dtWzHUcgvS3C/64hIrmG2Sa3XsS
	XtYwu/D32ZMkdqlxl1aMca9JeEd6EP+b+zP/No9Lrc6hfZPBa0DJpf2mawWNDpYxmYGB/c5QrAb
	m0X+mQ7AwKcA6KW8PE9E74EUUbrtiQOQtukmfExeLgCQ6OIPTTWxD1MYHfc7WI+CAD43wco9qw+
	F1UcxxQ5oGRwPzn8KDDcUEnJr1JTJc90E1PKYFXEcqih7cEK8cdW8Vmxm06e275iD4PVl2UZ4I2
	43TKW5qtHFVRo4UEvT2EtgRiL/9pf3XeMn6Osit/si5CIAYlWAGzvnjuztEeiJzlVvkGg4JPEOL
	DUpQXWgh+yrN7xY17BocLS+Wuo1g==
X-Received: by 2002:a05:600d:4:b0:480:69b6:dfed with SMTP id 5b1f17b1804b1-488d68ab2bfmr302762205e9.24.1776351266415;
        Thu, 16 Apr 2026 07:54:26 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead2decafsm12915427f8f.0.2026.04.16.07.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 07:54:26 -0700 (PDT)
Date: Thu, 16 Apr 2026 16:54:23 +0200
From: Petr Mladek <pmladek@suse.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: chensong_2000@189.cn, rafael@kernel.org, lenb@kernel.org,
	mturquette@baylibre.com, sboyd@kernel.org, viresh.kumar@linaro.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	bmarzins@redhat.com, song@kernel.org, yukuai@fnnas.com,
	linan122@huawei.com, jason.wessel@windriver.com, danielt@kernel.org,
	dianders@chromium.org, horms@kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	paulmck@kernel.org, frederic@kernel.org, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com, rostedt@goodmis.org,
	mhiramat@kernel.org, mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
	linux-pm@vger.kernel.org, live-patching@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with
 double-linked list for reverse traversal
Message-ID: <aeD4H8P1DiPQoM8V@pathway.suse.cz>
References: <20260415070137.17860-1-chensong_2000@189.cn>
 <20260416133004.07bd2886@pumpkin>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416133004.07bd2886@pumpkin>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2368-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[189.cn,kernel.org,baylibre.com,linaro.org,redhat.com,fnnas.com,huawei.com,windriver.com,chromium.org,davemloft.net,google.com,suse.com,atomlin.com,suse.cz,goodmis.org,arm.com,efficios.com,vger.kernel.org,lists.linux.dev,lists.sourceforge.net];
	RCPT_COUNT_TWELVE(0.00)[48];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,pathway.suse.cz:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C1DE540FEB9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu 2026-04-16 13:30:04, David Laight wrote:
> On Wed, 15 Apr 2026 15:01:37 +0800
> chensong_2000@189.cn wrote:
> 
> > From: Song Chen <chensong_2000@189.cn>
> > 
> > The current notifier chain implementation uses a single-linked list
> > (struct notifier_block *next), which only supports forward traversal
> > in priority order. This makes it difficult to handle cleanup/teardown
> > scenarios that require notifiers to be called in reverse priority order.
> 
> If it is only cleanup/teardown then the list can be order-reversed
> as part of that process at the same time as the list is deleted.

Interesting idea. But it won't work in all situations.

Note that the motivation for this update are the module loader
notifiers which are called several times for each loaded/removed module.

Best Regards,
Petr

