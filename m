Return-Path: <live-patching+bounces-2890-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GHXPKg2fFWr9WgcAu9opvQ
	(envelope-from <live-patching+bounces-2890-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 15:24:29 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 256125D6625
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 15:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4907930D5E27
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 13:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F223FBEA3;
	Tue, 26 May 2026 13:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N3MC34xt"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFCC3FBB67
	for <live-patching@vger.kernel.org>; Tue, 26 May 2026 13:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801190; cv=none; b=lOysg2tMA5K0gNAaafwwBoer4UqShgQMyzcORzBbqM8QVg11/nmppRUNJ2jQR5qcnCoJ1nGqnlhLb69whF+zI7OyOwBu9l2WtYZk2WTQZMXS8tSkpQshtW7rHzqiweCzhEm56CgEP9yDwoFeyOKD4t4EsrqIoAMH/izNcqtK3JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801190; c=relaxed/simple;
	bh=J5D53oHKCgGzVGJBu07gqgGh/ye/Ed29NgZWZAutzxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EyXWhzy8dHxTFoFTcTIXd3/VK6NHZVawnh2lNa/fz+NIb3aqw7fG/7xjIReNf+VqjKzZL7dLY3Jsu7t+jrW+XB//+df4PruK4u74AH/1yFsViDyyRwlknMWhz/Y4rU+w9ir1lmXbmjGNuDDrpvLFbyAU7rnh+2/sHJvfr1O1OTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N3MC34xt; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48e6db3ff7eso54563125e9.0
        for <live-patching@vger.kernel.org>; Tue, 26 May 2026 06:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779801187; x=1780405987; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4F9B7tafR/ijsY9adgUj8UiiCy4/8yDhFSR6oHsyOpk=;
        b=N3MC34xtdrAHu789efUPK2MKUbJZ8BirCkpqoZ27mtD+p0sX/rtVwc1Ebs6HhwuloT
         usyvj7ZRm8K9cdpYUjHtO+GCCmfUS5FHOm8jWRBoSlGcaZ0L4aAjXDm5Kg7QFL9iBRj+
         2uqSdw3O8hwqYgnVQ1P1zwKceO+4WK5lLWgSoSnDST3iUK+ERwlr1fGLLXUpCIip/mk/
         lzUKO8fzNMXumjI/kQIBLB6X9cM2Sm95B7DMNHRT7tPYhZGAWeC+RBwwLGkxJumLFBAU
         jXjhsxmNgnk1Wm7Oeti5MiW2/lEuYEvTk+PDXXnro0vGPfQ0z13GrRez/iws2fpz3PKJ
         vDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779801187; x=1780405987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4F9B7tafR/ijsY9adgUj8UiiCy4/8yDhFSR6oHsyOpk=;
        b=oQLPeWHE0SwIADC7VAX1Yh6nydXdh8KfGs7oB78yxSBmxoS6sMkUjwJl0tHI/KPRzc
         WcLNCcNLPkgtQRlEAP4pi+gZloMzkoCOvyofsE/jYb3faswo1nVndjk/FDi2RRs6JEeJ
         MQSmC2HcBKEplrNoHcWHFxfkMPTmraigMxr6FaSnWcl02+zU+OiTBOFR2/JYeIrHY2V1
         MIFJwLhhDfCC43EsRiFb7gMJ/zE0KC6gwa8WQ5kQYpLSqHg4iO58lbc6GO9yfIUM2NOC
         Jike30OaiATSngu9aGqGKBvrQqEixcCir51p0bB+lCJ6qK1FiHl59FlWqm65RYPFmSwD
         6FxA==
X-Forwarded-Encrypted: i=1; AFNElJ/zgeW96Ws0qse6PgpO+PNwbvw6Vrmf6mrW+JuwcpwNVDXYHiVFUmO0D3dt2JRQlvw1bq3v3YzRQJYJAJyo@vger.kernel.org
X-Gm-Message-State: AOJu0YxUsdLHtO6hydMkVus9aXS49ogqqDryZQncTRixQhY3QJuYRV0l
	3h2stcCDgAzXI90f6yeQQH89a8558AFvCMahtidv7eeKDIUyzJRaBKON9EM2ywa1Juo=
X-Gm-Gg: Acq92OEBYZHmTRTeNrHYUApXtjQ7QZll9UAI2Au6+hYyFNe3oJzys7tkC++p9gtU4EC
	2SfIX7CN0hdupkOFnWHTtTEYO8ums1saU6rElW9rbRdZgSOZLN5iVnUFDd7CR9VZO4sle8HHBw4
	9GHY0EIQTiWbo6Zhk2HkP/MyI4PKzBfb9SWc+dElx40dwbieX0IcvfEgGc8WupAVCmJuSM/eyea
	qevywH43X4XQxmClmPZ0vbTlPEVR+cy1FjfLYohvmb0v2FIwcRfirTbP3XQFzfeQwEeZRyZLynE
	dfnQyaPHx1KdmasOBiHLUUcHIop/JtMF5FCo+0SyIe6xSDZtQZkWMxqdG6nRmG2GsOptxAcVrka
	fyfQOrsXkCruZE6uqKOvmc+82MV5cNeBdSOnEsqhKII5notYVInEAEq+47ZAX3CGqg3sH9g7fx+
	HgLzl3aORdXwCSR8rEZRslQZ11dkF/jlLghvow
X-Received: by 2002:a5d:5f90:0:b0:43d:781d:37b9 with SMTP id ffacd0b85a97d-45eb3af9bd3mr31708410f8f.42.1779801186906;
        Tue, 26 May 2026 06:13:06 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9f58dsm34856649f8f.5.2026.05.26.06.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 06:13:06 -0700 (PDT)
Date: Tue, 26 May 2026 15:13:04 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, song@kernel.org,
	live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] livepatch: Introduce replace set support
Message-ID: <ahWcYIFs408vuvGP@pathway.suse.cz>
References: <20260513143321.26185-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513143321.26185-1-laoar.shao@gmail.com>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2890-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,pathway.suse.cz:mid,suse.com:dkim]
X-Rspamd-Queue-Id: 256125D6625
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed 2026-05-13 22:33:15, Yafang Shao wrote:
> We previously proposed a BPF+livepatch method to enable rapid
> experimentation with new kernel features without interrupting production
> workloads:
> 
>   https://lore.kernel.org/live-patching/20260402092607.96430-1-laoar.shao@gmail.com/
> 
> In the resulting discussion, Song and Petr suggested adding a "replace set"
> to support scenarios where specific livepatches can be selectively replaced
> or skipped.
> 
> - Patch #1:
>   Adds replace set support for livepatch functions.
> 
> - Patch #2~#5:
>   Derived from Petr's original patchset:
> 
>     https://lore.kernel.org/all/20250115082431.5550-3-pmladek@suse.com/
> 
>   All the selftests are not included in this RFC.
>   Note: Due to a significant refactor in Patch #5, I have omitted Petr's
>   Signed-off-by for that specific patch. Please let me know if this is not
>   the preferred approach.

I am not going to review these patches in this round. They are based
on an outdated RFC. I guess that they do not handle feedback against
the RFC. Also they would require massive changes in the selftests.

Note that I have already done most of the work, see
https://github.com/pmladek/linux/tree/klp-state-transfer-v1-iter12
It requires rebasing on top of last linus tree and some
clean up.

I still hope that I will be able to work on it rather sooner
than later.

> - Patch #6:
>   Adds replace set support for the shadow variable API.

Best Regards,
Petr

