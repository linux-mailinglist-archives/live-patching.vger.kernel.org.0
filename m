Return-Path: <live-patching+bounces-1509-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B30B4AD2BFA
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 04:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 902D23AF79A
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 02:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453D525E464;
	Tue, 10 Jun 2025 02:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gDNzzvxL"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D39E219FC
	for <live-patching@vger.kernel.org>; Tue, 10 Jun 2025 02:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749522899; cv=none; b=gFPWgxJsM4QOmN4uJMkXzLtvGkkZwLeFZ6arsvYm6Go4wMSTtU/9qc0JGwqOO/T/AcjAV2ZDLC8PbNRJSXRncZ73Byp6xXz3UnI8ExOtulrsp7FJvPryKcy/CfgBrd+Ys3HqyNne3wyjjlYYIDlmO3uJ8TSQPKrr4oX3ckVnb3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749522899; c=relaxed/simple;
	bh=tp8L0BAtSL5ESq9LFjxdaRFJAyqYWmFXOftN6Knq36U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tp8R9TazZ2e/NjgC5Wl5bCqzj+5NcJsFQQfsE88Bz9xUPuPt7gPGDPR+xGMy74YjqMgfdTDO00kGYPRLr9PmDmlwhYr85t7iAQFILyVQeTHJR2YubAwBjLenv4WFjHNrjy74qCtiLBl8ya21Wol1jXZjkAXVmyfO3ONgMukhOss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gDNzzvxL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749522896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JZMpQ5XItSawPL6rw4iOUVcSAdD3ZFNQ86Q+6qjE8vc=;
	b=gDNzzvxLfSeHmUO//nvyrcqi7x1FFkps8sJN2l49OcqmLoyQMHzmKyeJEsC2ezcSGUjdBH
	Hs0Y5+CwBmCGW8nTSbspNwTqt+A/z37OkmaqjKBJNfiGYOf95AW5vnY7CQYjDAgNjgvi/v
	clt9Wr9/3fKEtFBhUyjsC3291u/U764=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-mkdENwJONKqVxRxg4ErcCg-1; Mon,
 09 Jun 2025 22:34:51 -0400
X-MC-Unique: mkdENwJONKqVxRxg4ErcCg-1
X-Mimecast-MFC-AGG-ID: mkdENwJONKqVxRxg4ErcCg_1749522890
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 375F719560AD;
	Tue, 10 Jun 2025 02:34:49 +0000 (UTC)
Received: from redhat.com (unknown [10.22.81.60])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FBCC195608D;
	Tue, 10 Jun 2025 02:34:45 +0000 (UTC)
Date: Mon, 9 Jun 2025 22:34:43 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
Message-ID: <aEeZw4PTeOIe-u_d@redhat.com>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, May 09, 2025 at 01:17:23PM -0700, Josh Poimboeuf wrote:
> +revert_patch() {
> +	local patch="$1"
> +	shift
> +	local extra_args=("$@")
> +	local tmp=()
> +
> +	( cd "$SRC" && git apply --reverse "${extra_args[@]}" "$patch" )
> +	git_refresh "$patch"
> +
> +	for p in "${APPLIED_PATCHES[@]}"; do
> +		[[ "$p" == "$patch" ]] && continue
> +		tmp+=("$p")
> +	done
> +
> +	APPLIED_PATCHES=("${tmp[@]}")
> +}

You may consider a slight adjustment to revert_patch() to handle git
format-patch generated .patches?  The reversal trips up on the git
version trailer:

  warning: recount: unexpected line: 2.47.1

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index f7d88726ed4f..8cf0cd8f5fd3 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -345,7 +345,8 @@ revert_patch() {
 	local extra_args=("$@")
 	local tmp=()

-	( cd "$SRC" && git apply --reverse "${extra_args[@]}" "$patch" )
+	( cd "$SRC" && \
+	  git apply --reverse "${extra_args[@]}" <(sed -n '/^-- /q;p' "$patch") )
 	git_refresh "$patch"

 	for p in "${APPLIED_PATCHES[@]}"; do


