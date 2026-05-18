Return-Path: <live-patching+bounces-2842-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KD9mCkylCmqu4gQAu9opvQ
	(envelope-from <live-patching+bounces-2842-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 07:36:12 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AA85566561
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 07:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4FB1E306A990
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 05:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16B43B3C10;
	Mon, 18 May 2026 05:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocqVxHKK"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F018F39768F;
	Mon, 18 May 2026 05:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779081788; cv=none; b=IaQVYXpkhz79064W4rQNdLfyir5dG7t6GSyUctWQRRhlKOdy30u820pl4Vsi7MuoLfk9pT+qmPnKJU51ik5IG9H0KjUC3GpK874zKH8X1BzPhSGC50rWv+nzO3t+M5VwNoHnwj/Ih5Zy1eQaXZU1pu0Ycd0nYi5/qcBaz8fRMdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779081788; c=relaxed/simple;
	bh=mrZ9JS0lowRYa4TgHfZexPiVZyxW+k/T0hRvjSpzozE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fho7pKKVwmo/dS95zVy1cyQ18oMRiTv4WM4jX5ZMuon8Ed1h29Hfi/qAspd9PltNgn3oUjzKfZf0i/7vEs63Cc0KtU9JRhVSl4Fv45mZJrGup/LkX6RMnL/YGvZ4fru6Ae0XtudVbmqBfKGBsZCtkYLVHcvChKi7+90fh6mCruc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocqVxHKK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADC7C2BCB7;
	Mon, 18 May 2026 05:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1779081787;
	bh=mrZ9JS0lowRYa4TgHfZexPiVZyxW+k/T0hRvjSpzozE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ocqVxHKKlF+uN/UaIjV2Dz7FUl+pAceJ0qAUyqgk2mH8DCn4H+XAFeCOcKOhqt+4K
	 Js7FCDMqgQx9kHV5OU3/nbHu6t3LhbJXZxIHol6bv2wdlbBcYiLsGxvZhiff9uYgQe
	 03NM0M7f0cnW6lbB8i3WZ+a7htZNbUtAVBfSo2lQ=
Date: Mon, 18 May 2026 07:23:11 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brandon Taylor <bt610490@yahoo.com>
Cc: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	bpf@vger.kernel.org, live-patching@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Florian Weimer <fw@deneb.enyo.de>, Breno Leitao <leitao@debian.org>,
	Anthony Iliopoulos <ailiop@suse.com>,
	Michal Hocko <mhocko@suse.com>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH v3] killswitch: add per-function short-circuit mitigation
 primitive
Message-ID: <2026051854-emphases-cascade-29ee@gregkh>
References: <20260508195749.1885522-1-sashal@kernel.org>
 <20260517134858.146569-1-sashal@kernel.org>
 <e4527b42-f2e6-447a-861d-580a521bde19@yahoo.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4527b42-f2e6-447a-861d-580a521bde19@yahoo.com>
X-Rspamd-Queue-Id: 7AA85566561
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[yahoo.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2842-lists,live-patching=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linuxfoundation.org:dkim]
X-Rspamd-Action: no action

On Sun, May 17, 2026 at 02:19:35PM -0500, Brandon Taylor wrote:
> Have we learned NOTHING from just over 9 and a half years ago?!
> 
> I do not pretend to be a prophet of Linus, but I cannot for the life of me
> help but get flashbacks from kernel version 4.8 when Linus himself did not
> explain, but EXPLODED, in saying "there is NO F*CKING EXCUSE to knowingly
> kill the kernel."

That's not what this patchset does, sorry.

best of luck!

greg k-h

