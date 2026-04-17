Return-Path: <live-patching+bounces-2392-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yHz4ITF+4mnk6gAAu9opvQ
	(envelope-from <live-patching+bounces-2392-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 20:38:41 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E300841E016
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 20:38:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7354B306B3AF
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 18:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC253BD646;
	Fri, 17 Apr 2026 18:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aZd5g+ev"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E45136EAAD
	for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 18:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776450997; cv=none; b=jafqroAn2i29o49IVm6vmNQTjgrWi+e2I3ASdO/UMlaGVoASCrqxEduIA393MCT+wkn1NeDPEy4iXXgAMFGtleXbJAlzAcu3554RbxnOrqpp8u6O0lghA4TH1Vg9e6+n35FPubMK4LV5DMvRk25eWYRGb9mOTwXrw4J5LLiHKrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776450997; c=relaxed/simple;
	bh=jhi8Q9sKzMlM9j3Xkto1ZUlcQv/ROlzg10YIqA3tX1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RaCZJMOUogri6tLltat5nMlW92j8gRENyL/LI8OhnKPiAmhHZAtkaFwmkQBy8PYirk4DaKKn24C8uh4734b+/99mZiHaspFzxek03AR/NJkVWb8FKQGJLw2jQVz6xJkxwSyFkimSmmeEh2QSipi0pZ6UGmErS7rYebgrAjRgINY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aZd5g+ev; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776450993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qzO4xHkNqCBbD3gDH7u2XXP1am7OmyGOsroGGiFrSjc=;
	b=aZd5g+eviqD2RpBNvnaRSqz0NXDMznneWurEdaj/VH4VD+VyW9rfF4nGU3UXg8mNxBQCfL
	9tVGesPrQ96NhkTuF/qcE6vPdhjWJu7mz54dstmuuQvJodXp4v6C7kozKdNq7i+j+mq+SI
	MQ8HwWdcpi11nSdPEyA0SuIAboX+2/U=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-cFxf94TMPoStTwVXHme2-Q-1; Fri,
 17 Apr 2026 14:36:28 -0400
X-MC-Unique: cFxf94TMPoStTwVXHme2-Q-1
X-Mimecast-MFC-AGG-ID: cFxf94TMPoStTwVXHme2-Q_1776450986
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8C2718005A9;
	Fri, 17 Apr 2026 18:36:26 +0000 (UTC)
Received: from redhat.com (unknown [10.22.88.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25F4E1800906;
	Fri, 17 Apr 2026 18:36:25 +0000 (UTC)
Date: Fri, 17 Apr 2026 14:36:22 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] kselftests: livepatch: Adapt tests to be executed
 on 4.12 kernels
Message-ID: <aeJ9pn6v5sGq5nln@redhat.com>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
 <wrecfrmldslvr4dvtb7hrmi3w6joby4qmray3fd3f4dfc2k2tv@ficeojpjxjop>
 <5fb3ecf5a13bdf459019f6f011f3507593498875.camel@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fb3ecf5a13bdf459019f6f011f3507593498875.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2392-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E300841E016
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 16, 2026 at 03:18:33PM -0300, Marcos Paulo de Souza wrote:
> On Thu, 2026-04-16 at 10:07 -0700, Josh Poimboeuf wrote:
> > On Mon, Apr 13, 2026 at 02:26:11PM -0300, Marcos Paulo de Souza
> > wrote:
> > > A new version of the patchset, with fewer patches now. Please take
> > > a look!
> > > 
> > > Original cover-letter:
> > > These patches don't really change how the patches are run, just
> > > skip
> > > some tests on kernels that don't support a feature (like kprobe and
> > > livepatched living together) or when a livepatch sysfs attribute is
> > > missing.
> > > 
> > > The last patch slightly adjusts check_result function to skip dmesg
> > > messages on SLE kernels when a livepatch is removed.
> > 
> > Why are we adding complexity to support Linux 4.12 in mainline? 
> > Isn't
> > that what enterprise distros are for?
> 
> These changes do not add any new complex code, just checks to enable
> the tests to run on older kernels. I believe that it would be good for
> all enterprises distros if they could run more tests in maintenance
> updates of their kernels using the upstream tests.
> 
> The changes are not really that big. Some patches were removed from v1
> because there were adding checks for out-of-tree messages (like the
> last paragraph of the v2 erroneously shows), and another one was to
> check if kprobes could live alongside livepatches, which fails for 4.12
> kernels.
> 
> The patches for this versions introduce only checks to avoid testing
> sysfs attributes for kernels that don't supports them.
> 

IMHO when the changes are reasonably small, I think we should consider
accomodating older kernels for the selftest suite.  If we reach the
point of having to introduce version #ifdef-erry, that opinion would
flip pretty quickly.  It's pretty amazing that modern tests still run on
older kernels (with this patchset) -- not an explicit kselftest goal
AFAIK, but nice to have.

If we do merge this patchset, it should update the doc
tools/testing/selftests/livepatch/README to note the oldest
expected/tested upstream kernel.  (So new selftest authors may have some
idea of what API / sysfs features to use.)  And that this compatibility
was only an incidental "feature" that came for nearly free.  It's not a
promise to never add backwards-incompatible tests in the future.

--
Joe


