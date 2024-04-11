Return-Path: <live-patching+bounces-227-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 61F108A165F
	for <lists+live-patching@lfdr.de>; Thu, 11 Apr 2024 15:58:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC84BB236DE
	for <lists+live-patching@lfdr.de>; Thu, 11 Apr 2024 13:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D543B14D703;
	Thu, 11 Apr 2024 13:58:50 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C4713FD8B;
	Thu, 11 Apr 2024 13:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712843930; cv=none; b=Pc7tbi136ZFsztRxzEiwCAlCYFSCzFfx5wu6w4TjcNqhKRa1dKAaDzMyq/MS/y+1l9BX6e0qvReJUgZvKQn9uW0RkHxuVmX9BifSnN+fVfqoizSfPgy1yhVqqxHmqvCHkS69V9n6I/vSojvzZHfE1VRVfrUoopt2fONuQUOFloo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712843930; c=relaxed/simple;
	bh=h37q1JIdVNeibGVDpMNVz8aJvRk5njrnrSPrB8ySvdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=roIrHtaBkggAWFgolf4um1UUnIQO0ZPfDhY0k3kpQB+8CxnBP0X+hwXc5bHukc7z6lil1Pl/u4OlxNkjEEftIaUr0BdUm1uL3cIuhpoK4QskJF0iukE1zhXo/2zM7ne62zywHiWxkOz/+oOmddolZmfdcnSmKMnqQt5oH87OgRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 777475CB01;
	Thu, 11 Apr 2024 13:58:47 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D758139DE;
	Thu, 11 Apr 2024 13:58:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VvCMAJfsF2YjOwAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Thu, 11 Apr 2024 13:58:46 +0000
Date: Thu, 11 Apr 2024 15:58:21 +0200
From: Lukas Hruska <lhruska@suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>,
	Petr Mladek <pmladek@suse.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v1 0/5] livepatch: klp-convert tool - Minimal version
Message-ID: <ZhfsfeuObW53kcCC@dhcp182.suse.cz>
References: <20240410153220.15927-1-mpdesouza@suse.com>
 <alpine.LSU.2.21.2404110825190.30783@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2404110825190.30783@pobox.suse.cz>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 777475CB01
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action

Hi,

> > Do we have anything that blocks klp-convert-mini to be merged, or something that
> > needs to be fixed?
> 
> there is feedback from Petr and I agree with him that a selftest would be 
> appropriate.
> 
> Lukas, are you planning to send v2 with everything addressed?

Yes, I definitely want to send v2 soon. I am starting to work on it
today and hopefuly I will be able to send it next week.

Lukas

