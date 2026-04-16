Return-Path: <live-patching+bounces-2377-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qKAaLtw14WkEqgAAu9opvQ
	(envelope-from <live-patching+bounces-2377-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 21:17:48 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09F7A414065
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 21:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3145B30EC4F2
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 19:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43CB35C19F;
	Thu, 16 Apr 2026 19:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QY8Id/xC"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4927735DA78
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 19:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776366947; cv=none; b=Cvk4RuxPf77oBCuUgK1cHpz+enRzkyoK0p9dtX/mTXicZSG58+MbNRYXeoM3EIMn9eAwu4zJq7Azbe7G1zKzdk9PY37GfQ0NTmEVZLxZBT/6UPbsT/cA6nkdSIchxxgbcQNfl5s1IyYaua5Apy3WsV9XyHZpNM9wEb911dR95Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776366947; c=relaxed/simple;
	bh=OJeI+3mV9W6ncnLD1OqQ+pA6ULnbFdUSlKq0JT7njbc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWcJIcaAEADSXJXMKNA3N0h0OTLNVisFQdXuWgQQDeFjLVWcavJVtgN3MrqoPEUwL9PKWQJz3eYRXnTrUgqMdT9YxNgxF2DujZfyAwhMyvxqiZR4EqdT4n0H+3mfbTGcQ24jadlTz+5x8s+InLeC97gWMgYmh4VoHvoB7u40OqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QY8Id/xC; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso79035195e9.3
        for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 12:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776366942; x=1776971742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GI2dSkxrwqhQpR5uFXP6GxtJ/asEeAYI1RS8A1ZzV9c=;
        b=QY8Id/xCkNSDyRp/6Ia+IhGODB81KC4sCUqlBNfTsAhr60CKClN3QAh6bbWUbx9w0F
         bowURat77zHN+ZHlfvOuP63DWSZJLS9CB67JIgVAKCi6+vwdDnB0WCbS+mhqXyCZvNgH
         3LgovKTZOOZSrowianOqjoxUQU00rBtvbO969KTtzDkyjg4GJlw/bqQS1tjsfKG/nQPm
         ogEfTFcSlOlyCQukZYVXoZ8VBq3hePPIvwrDjEotzfkKEEGQrm4PF/3sJRfFVVsqc4hv
         U3krfzau87CZFEd4MdPgtiuytDHml1jLJtOQsqDYRuR1b6pukPY/ROgrGM7JVAH/3WFp
         ckmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776366942; x=1776971742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GI2dSkxrwqhQpR5uFXP6GxtJ/asEeAYI1RS8A1ZzV9c=;
        b=Y46zfp4SaLEliK3fnOcWkVj7nPY4Wvb5be5aLwxbIIgxFw5bL3O5Qu/mM9U2U51xRJ
         2Frbbvbs39QSyMQuP/OnrswmoC5X9c/evRJerIhfx/ps9MeQHaHNx4kCDn1BW/9m2qrT
         aFNDmVXV8cg+YkpR0MED6Vpp3ydv+AF/SZR8hQaO8xiYVyEuJ+p5uzMYsUWhAEMZZX+2
         9qWHnUkG/1a01GmTZXJiDz66ml3MTLOrWCWw3hJsinjI2A30mNEq2G/KF9IVG/uYvDoH
         hvc/QMQGvpOwPsC5BEBRpULOCI5Rfz9RHnEjLXAQr4QdTVx5FQJDYZe6Bsu/upQvnwYE
         Y7Aw==
X-Forwarded-Encrypted: i=1; AFNElJ/4Znpc3++iNn6WBp/ADNN39l9PZ9clHS0+v8kqDO48Cd9ZA9HBm2zLjIKdiWa4/1YYguH3wO2UTiEhCfAL@vger.kernel.org
X-Gm-Message-State: AOJu0YynKjhJpkOWqGnKJ86dRQTmHqDiCIul67PGcHMa9KLCI35Bf54Y
	XJMl+rbdjA/tiAG6Iltu996qpVhzr6/AJAvzlnVfznZzQYShz9rbTuGQ
X-Gm-Gg: AeBDiesM/drUq0bnkZ9Fq/5Aax8k3zLgk3fEqPEckacCGOdUcXkqzzPQPY5ZtwUmP8M
	lJwyi0+Wfb5W5HUo0gZQRDXRZG+Zob4am3Md4tzUrSVhXQIPkSfAqy9D6OSfFJLHXWZpj+hljp6
	n6FON1ntOG3ZsCfqsNZfjM1l6PT0yqAPKE4Ab9gJIEp6iWmH/o7+IcJPcqG6Yup0jzSig3P3LHD
	l4+63RkwBJ6I/J+W/0W7ZlmxQAuRPKZTHa+walb1cbS5XaOudSORGCu4NduH14Ey44DB7aG5BNL
	isj/+1P/5Z4IO0RNZnV+WsdgHu4m5nXKrGwZqCXR/M7dhwNUszMzibLJup5erpu6eQLfk3tdb0V
	YRi7cs8CmNPmum8wZ7jTYPJeKWIuwu+cDwjjOOIrO8xXMKY/OJMXDfxX1lFg9IDs5m5/eVARnO2
	HKBKGiXd0Af3amEjoh/cWH2skH60tkOTr2LszpYvjNx6F6GeFiO9LSaykI1K5TeBj1/3jkdgfNm
	OU=
X-Received: by 2002:a05:600c:a415:b0:485:419c:4eba with SMTP id 5b1f17b1804b1-488fb26d43fmr1783635e9.1.1776366941546;
        Thu, 16 Apr 2026 12:15:41 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3d5f06sm16561608f8f.17.2026.04.16.12.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 12:15:41 -0700 (PDT)
Date: Thu, 16 Apr 2026 20:15:39 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Petr Mladek <pmladek@suse.com>
Cc: chensong_2000@189.cn, rafael@kernel.org, lenb@kernel.org,
 mturquette@baylibre.com, sboyd@kernel.org, viresh.kumar@linaro.org,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, song@kernel.org, yukuai@fnnas.com,
 linan122@huawei.com, jason.wessel@windriver.com, danielt@kernel.org,
 dianders@chromium.org, horms@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 paulmck@kernel.org, frederic@kernel.org, mcgrof@kernel.org,
 petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
 atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
 joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org,
 mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
 live-patching@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
 netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list
 with double-linked list for reverse traversal
Message-ID: <20260416201539.2cee3b99@pumpkin>
In-Reply-To: <aeD4H8P1DiPQoM8V@pathway.suse.cz>
References: <20260415070137.17860-1-chensong_2000@189.cn>
	<20260416133004.07bd2886@pumpkin>
	<aeD4H8P1DiPQoM8V@pathway.suse.cz>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2377-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[189.cn,kernel.org,baylibre.com,linaro.org,redhat.com,fnnas.com,huawei.com,windriver.com,chromium.org,davemloft.net,google.com,suse.com,atomlin.com,suse.cz,goodmis.org,arm.com,efficios.com,vger.kernel.org,lists.linux.dev,lists.sourceforge.net];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[48];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,189.cn:email]
X-Rspamd-Queue-Id: 09F7A414065
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, 16 Apr 2026 16:54:23 +0200
Petr Mladek <pmladek@suse.com> wrote:

> On Thu 2026-04-16 13:30:04, David Laight wrote:
> > On Wed, 15 Apr 2026 15:01:37 +0800
> > chensong_2000@189.cn wrote:
> >   
> > > From: Song Chen <chensong_2000@189.cn>
> > > 
> > > The current notifier chain implementation uses a single-linked list
> > > (struct notifier_block *next), which only supports forward traversal
> > > in priority order. This makes it difficult to handle cleanup/teardown
> > > scenarios that require notifiers to be called in reverse priority order.  
> > 
> > If it is only cleanup/teardown then the list can be order-reversed
> > as part of that process at the same time as the list is deleted.  
> 
> Interesting idea. But it won't work in all situations.

It is useful for things like locklessy queuing a request to be processed later.
Items can be added with a cmpxchg and the list grabbed by xchg of NULL.
The only downside is that reversing a list isn't cache friendly.
Thinks... although that may not be any worse than accessing the current 'tail'
to add to the end of a doubly linked (or singly linked with a tail ptr) list.

	David

> 
> Note that the motivation for this update are the module loader
> notifiers which are called several times for each loaded/removed module.
> 
> Best Regards,
> Petr
> 


