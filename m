Return-Path: <live-patching+bounces-2402-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMbIF+/25WnjpgEAu9opvQ
	(envelope-from <live-patching+bounces-2402-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 11:50:39 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CF04290DE
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 11:50:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4003A309131B
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 09:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90FD13914FD;
	Mon, 20 Apr 2026 09:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vSMMRm2G";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SJcYhERc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vSMMRm2G";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SJcYhERc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B29538F947
	for <live-patching@vger.kernel.org>; Mon, 20 Apr 2026 09:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776678408; cv=none; b=F2aRZTxhjRs603mq5fYwdUdkzBSpNPGbFLnF9pmiIGjjk8bqBIqcdS66BWbuQav7mCOWaHhS5sBdXvFtpVndB+SC9TAXASMKz53lFs+GNiFCjqpNMR1NfenbnGPwdxYDzk+e8kRwsJyrTxzNWGrDJ7j/rTdbzURYBRne6EK6D2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776678408; c=relaxed/simple;
	bh=LxKtPlsGjHGCsLEvJ5qrtOTlK3zheCU9r9WCCneQQ94=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bqpwy8pg7vAQEyH84CLLFi7xdl+iyDr31yZ6HrPZwNWD8xORwaOeQCJe1sCevuvy0/mW9cA1JfbDiLdfn/9PwrBg/iuStodtcbZM0HjBetd1KAJdBbFr7Ew//0CG8LAfnbWpLQNs5YKTA3BCI4buH0MjwK/dv321SbBTcRMQecM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vSMMRm2G; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SJcYhERc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vSMMRm2G; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SJcYhERc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8402E6A7D2;
	Mon, 20 Apr 2026 09:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776678405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QICAfPU5wlU/aFnTAQ1cZvh0W6tc1EFtdfhvMfiP3eI=;
	b=vSMMRm2G/VBPkDWYoo9lpLXIrIURLo86wh3S2CV70CUw9LCSPFy5B/yR1QkSCRolJl6XZf
	UsQhkAqz3eNOiZemSACKzR9oMjF6HKEEES/Hh0CtZKUpq+uNOCLLdpQnMCiY1SttOyO/7i
	kD50OH2hkSeSh0PwC5dI5ld2ynjyU3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776678405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QICAfPU5wlU/aFnTAQ1cZvh0W6tc1EFtdfhvMfiP3eI=;
	b=SJcYhERczWgiATU0eo2TEHSICZke3hsp+T0CfbaaJxWl19Wn2ruN/rAIrDgkDdxcGVgAWY
	b7GCNM8ypiouYxAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776678405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QICAfPU5wlU/aFnTAQ1cZvh0W6tc1EFtdfhvMfiP3eI=;
	b=vSMMRm2G/VBPkDWYoo9lpLXIrIURLo86wh3S2CV70CUw9LCSPFy5B/yR1QkSCRolJl6XZf
	UsQhkAqz3eNOiZemSACKzR9oMjF6HKEEES/Hh0CtZKUpq+uNOCLLdpQnMCiY1SttOyO/7i
	kD50OH2hkSeSh0PwC5dI5ld2ynjyU3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776678405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QICAfPU5wlU/aFnTAQ1cZvh0W6tc1EFtdfhvMfiP3eI=;
	b=SJcYhERczWgiATU0eo2TEHSICZke3hsp+T0CfbaaJxWl19Wn2ruN/rAIrDgkDdxcGVgAWY
	b7GCNM8ypiouYxAA==
Date: Mon, 20 Apr 2026 11:46:45 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Joe Lawrence <joe.lawrence@redhat.com>
cc: Marcos Paulo de Souza <mpdesouza@suse.com>, 
    Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>, Shuah Khan <shuah@kernel.org>, 
    live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] kselftests: livepatch: Adapt tests to be executed
 on 4.12 kernels
In-Reply-To: <aeJ9pn6v5sGq5nln@redhat.com>
Message-ID: <alpine.LSU.2.21.2604201146290.21177@pobox.suse.cz>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com> <wrecfrmldslvr4dvtb7hrmi3w6joby4qmray3fd3f4dfc2k2tv@ficeojpjxjop> <5fb3ecf5a13bdf459019f6f011f3507593498875.camel@suse.com> <aeJ9pn6v5sGq5nln@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-2146828000-1941054320-1776678405=:21177"
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	CTYPE_MIXED_BOGUS(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2402-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	MIME_TRACE(0.00)[0:+,1:+];
	DKIM_TRACE(0.00)[suse.cz:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,pobox.suse.cz:mid]
X-Rspamd-Queue-Id: B4CF04290DE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---2146828000-1941054320-1776678405=:21177
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 17 Apr 2026, Joe Lawrence wrote:

> On Thu, Apr 16, 2026 at 03:18:33PM -0300, Marcos Paulo de Souza wrote:
> > On Thu, 2026-04-16 at 10:07 -0700, Josh Poimboeuf wrote:
> > > On Mon, Apr 13, 2026 at 02:26:11PM -0300, Marcos Paulo de Souza
> > > wrote:
> > > > A new version of the patchset, with fewer patches now. Please take
> > > > a look!
> > > > 
> > > > Original cover-letter:
> > > > These patches don't really change how the patches are run, just
> > > > skip
> > > > some tests on kernels that don't support a feature (like kprobe and
> > > > livepatched living together) or when a livepatch sysfs attribute is
> > > > missing.
> > > > 
> > > > The last patch slightly adjusts check_result function to skip dmesg
> > > > messages on SLE kernels when a livepatch is removed.
> > > 
> > > Why are we adding complexity to support Linux 4.12 in mainline? 
> > > Isn't
> > > that what enterprise distros are for?
> > 
> > These changes do not add any new complex code, just checks to enable
> > the tests to run on older kernels. I believe that it would be good for
> > all enterprises distros if they could run more tests in maintenance
> > updates of their kernels using the upstream tests.
> > 
> > The changes are not really that big. Some patches were removed from v1
> > because there were adding checks for out-of-tree messages (like the
> > last paragraph of the v2 erroneously shows), and another one was to
> > check if kprobes could live alongside livepatches, which fails for 4.12
> > kernels.
> > 
> > The patches for this versions introduce only checks to avoid testing
> > sysfs attributes for kernels that don't supports them.
> > 
> 
> IMHO when the changes are reasonably small, I think we should consider
> accomodating older kernels for the selftest suite.  If we reach the
> point of having to introduce version #ifdef-erry, that opinion would
> flip pretty quickly.  It's pretty amazing that modern tests still run on
> older kernels (with this patchset) -- not an explicit kselftest goal
> AFAIK, but nice to have.
> 
> If we do merge this patchset, it should update the doc
> tools/testing/selftests/livepatch/README to note the oldest
> expected/tested upstream kernel.  (So new selftest authors may have some
> idea of what API / sysfs features to use.)  And that this compatibility
> was only an incidental "feature" that came for nearly free.  It's not a
> promise to never add backwards-incompatible tests in the future.

I agree with Joe on both points.

Miroslav
---2146828000-1941054320-1776678405=:21177--

