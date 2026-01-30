Return-Path: <live-patching+bounces-1945-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GKqHOIcXfWkGQQIAu9opvQ
	(envelope-from <live-patching+bounces-1945-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:41:43 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 44139BE793
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E14AF30097FE
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75691346777;
	Fri, 30 Jan 2026 20:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AiYbqz6q"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083622737F2
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 20:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769805701; cv=none; b=fQGicZzANgQOO8LGdrECivaTXVM48xwKSj+9ufVA0Xi5sgiyeihp0VzwvrE9/ktUg5RgJfarJ+X5Lmo9nWoqJ54tzB3vyG/BUnjXddLW+eFaXx3C4R2S8Ruk3blvhilXPKkJXt0MdAOeZ5piIz0j6v3ezJj26ophYYP+XtyX9rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769805701; c=relaxed/simple;
	bh=DGWP+hSNL4i+aGax8j03Bsf4hfTbjFeZbQ+YaVmGBcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ntYZ2nIjSZU1qZqtn0UDPyC1kol4nGVT0URZKIm5RpiFYZwAw7X+AsX157dt8ctjfkNa3GQegxICHEuKLXKTglchPwecz2kDPMAIR++YEHXO1dqH+7ZEd9VizKKq+PVXBRKB+j8wvvKYhM+lTJ7kBwDedcIKIQODYm0ypL2aiFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AiYbqz6q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769805698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h5zsPiyNMcVPElTZ1FXLo5GDo6C6nvRV/Obt9AjQ7qY=;
	b=AiYbqz6qTQ+TDyICDv3GhPG6kqFZx16XARnzTUgY2iqCsAAcg9C67pIv1U9ejlYzyKEaap
	x1ArHfqVaA6DutyqxnY3IwgxXcG2Lq5e2u4xtimiLJfH76jWq9xT4/EDVrOmQ3SgdSM9OY
	jRZwqaVYIChdPr6UkeC+Tblh7FSX+Gw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-398--U9HenPbMoCTZ6CykPoLqA-1; Fri,
 30 Jan 2026 15:41:36 -0500
X-MC-Unique: -U9HenPbMoCTZ6CykPoLqA-1
X-Mimecast-MFC-AGG-ID: -U9HenPbMoCTZ6CykPoLqA_1769805695
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96EC51956089;
	Fri, 30 Jan 2026 20:41:35 +0000 (UTC)
Received: from redhat.com (unknown [10.22.81.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 272FC1800840;
	Fri, 30 Jan 2026 20:41:33 +0000 (UTC)
Date: Fri, 30 Jan 2026 15:41:31 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 4/5] objtool/klp: add -z/--fuzz patch rebasing option
Message-ID: <aX0Xe8ERVjPeu24j@redhat.com>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-5-joe.lawrence@redhat.com>
 <fayrtgx5l5wvcwkuxqc4it3t4ft3o7rbn4uojtmzjxq66nniw7@v6om4zyepshh>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fayrtgx5l5wvcwkuxqc4it3t4ft3o7rbn4uojtmzjxq66nniw7@v6om4zyepshh>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1945-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 44139BE793
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 12:09:35PM -0800, Josh Poimboeuf wrote:
> On Fri, Jan 30, 2026 at 12:59:49PM -0500, Joe Lawrence wrote:
> > @@ -131,6 +133,7 @@ Advanced Options:
> >  				   3|diff	Diff objects
> >  				   4|kmod	Build patch module
> >     -T, --keep-tmp		Preserve tmp dir on exit
> > +   -z, --fuzz[=NUM]		Rebase patches using fuzzy matching [default: 2]
> 
> Ideally I think klp-build should accept a patch level fuzz of 2 by
> default.  If we just made that the default then maybe we don't need this
> option?
> 

Do you mean to drop the optional level value, or to just perform level-2
fuzz rebasing as a matter of course (so no -z option altogether)?

--
Joe


