Return-Path: <live-patching+bounces-2091-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yPT8HS4/oGmrhAQAu9opvQ
	(envelope-from <live-patching+bounces-2091-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 13:40:14 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D20B1A5CE7
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 13:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 42680301A786
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 12:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813E937BE9A;
	Thu, 26 Feb 2026 12:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BkoaZEoD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RELR8lJr";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BkoaZEoD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RELR8lJr"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2D34A33
	for <live-patching@vger.kernel.org>; Thu, 26 Feb 2026 12:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772109610; cv=none; b=WUw7PUCdHYZOG6kqsC/842SapjG2TJTzmntKsWKRve+Elm1ZqNaxiHnzu762SeN+AGtmyf194y/ssg/ZgeFTc+4ORsqp2qMBB9ZkweiP4tY82b1IwIKn/xlT6R+OHC/qNeVQJNbvUW5EhmE0/utokhjhi82EX96++h+hw9VO+Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772109610; c=relaxed/simple;
	bh=8EYnWjXzgNnzpHIGK2gx/dJeOkHpwQX8gDUqMSm3nDM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ek/fBh95IPNUvDgm0nr4+mbpwsdmbryr372AvKzEjmVN1xiROwhyOwAiDV+S+ZTNrLnbmhkCz9WascmDzbPOwybMqFFN+kVzYnhyry8Vj22ggzt+kSmt+hJYZEHMi45PzCITHwlAqhhg7XWzbYw6O8Ak16vwiOtDRzFRyq3a5uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BkoaZEoD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RELR8lJr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BkoaZEoD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RELR8lJr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 835DF40369;
	Thu, 26 Feb 2026 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772109607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jh1hfCe3yjHCvLdTZnowOydEEx+CtconMBd+C/55U/U=;
	b=BkoaZEoDhy3m2kK8AhnqwRUHbNtbClJG6ZLEQXpo4C8aToHXlo8PRLRj76yOjCKDgcB5jM
	Lr076GGqdIeE60BrSNOUS8Ri8qGW7VJ7mXYzy8Ebki/pg7ZQl8lvK0e9qFt2T3yXErbmmN
	W1XHDL8V4xhB2G4P+FAF5zyXo16p1is=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772109607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jh1hfCe3yjHCvLdTZnowOydEEx+CtconMBd+C/55U/U=;
	b=RELR8lJrJAW5S9rQG4eFhy9xCZBEnS2JgjTCs3Ic8EDhjpwPsSY14c5Fu/Z2/iGXz42X20
	6nYlUQi4tQz74AAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772109607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jh1hfCe3yjHCvLdTZnowOydEEx+CtconMBd+C/55U/U=;
	b=BkoaZEoDhy3m2kK8AhnqwRUHbNtbClJG6ZLEQXpo4C8aToHXlo8PRLRj76yOjCKDgcB5jM
	Lr076GGqdIeE60BrSNOUS8Ri8qGW7VJ7mXYzy8Ebki/pg7ZQl8lvK0e9qFt2T3yXErbmmN
	W1XHDL8V4xhB2G4P+FAF5zyXo16p1is=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772109607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jh1hfCe3yjHCvLdTZnowOydEEx+CtconMBd+C/55U/U=;
	b=RELR8lJrJAW5S9rQG4eFhy9xCZBEnS2JgjTCs3Ic8EDhjpwPsSY14c5Fu/Z2/iGXz42X20
	6nYlUQi4tQz74AAQ==
Date: Thu, 26 Feb 2026 13:40:07 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
cc: Joe Lawrence <joe.lawrence@redhat.com>, 
    Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>, Shuah Khan <shuah@kernel.org>, 
    live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests: livepatch: functions.sh: Workaround
 heredoc on older bash
In-Reply-To: <5ca16692b304185df695e517434b16e59cb15a42.camel@suse.com>
Message-ID: <alpine.LSU.2.21.2602261337170.5739@pobox.suse.cz>
References: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>  <20260220-lp-test-trace-v1-2-4b6703cd01a6@suse.com>  <aZx1ViTc7NJws-rf@redhat.com> <5ca16692b304185df695e517434b16e59cb15a42.camel@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-2146828000-1974840087-1772109607=:5739"
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	CTYPE_MIXED_BOGUS(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2091-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	MIME_TRACE(0.00)[0:+,1:+];
	DKIM_TRACE(0.00)[suse.cz:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.cz:dkim,test-ftrace.sh:url]
X-Rspamd-Queue-Id: 0D20B1A5CE7
X-Rspamd-Action: no action

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---2146828000-1974840087-1772109607=:5739
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi,

On Mon, 23 Feb 2026, Marcos Paulo de Souza wrote:

> On Mon, 2026-02-23 at 10:42 -0500, Joe Lawrence wrote:
> > On Fri, Feb 20, 2026 at 11:12:34AM -0300, Marcos Paulo de Souza
> > wrote:
> > > When running current selftests on older distributions like SLE12-
> > > SP5 that
> > > contains an older bash trips over heredoc. Convert it to plain echo
> > > calls, which ends up with the same result.
> > > 
> > 
> > Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
> 
> Thanks for the review Joe!
> 
> > 
> > Just curious, what's the bash/heredoc issue?  All I could find via
> > google search was perhaps something to do with the temporary file
> > implementation under the hood.
> 
> # ./test-ftrace.sh 
> cat: -: No such file or directory
> TEST: livepatch interaction with ftrace_enabled sysctl ... ^CQEMU:
> Terminated

I cannot reproduce it locally on SLE12-SP5. The patched test-ftrace.sh 
runs smoothly without 2/2.

linux:~/linux/tools/testing/selftests/livepatch # ./test-ftrace.sh 
TEST: livepatch interaction with ftrace_enabled sysctl ... ok
TEST: trace livepatched function and check that the live patch remains in effect ... ok
TEST: livepatch a traced function and check that the live patch remains in effect ... ok

GNU bash, version 4.3.48(1)-release (x86_64-suse-linux-gnu)

Does "set -x" in the script give you anything interesting?

Miroslav
---2146828000-1974840087-1772109607=:5739--

