Return-Path: <live-patching+bounces-1322-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F26B6A6E27F
	for <lists+live-patching@lfdr.de>; Mon, 24 Mar 2025 19:37:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5054B3A725D
	for <lists+live-patching@lfdr.de>; Mon, 24 Mar 2025 18:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD514264F84;
	Mon, 24 Mar 2025 18:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ix0kqUe+"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED51264A6C
	for <live-patching@vger.kernel.org>; Mon, 24 Mar 2025 18:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742841382; cv=none; b=T83xu2rmezUX4zUXgLbKC2/CMTcMcF0rhW2sKkP3FReSzkbyrNiYjg6Q6MwAXQoluUFXbxBBuqLpa3slipzo/UC37DBsjnaCkpzg18IaEseQwisQ4rTOBI0DAfqCn/LGyy1Htha3aae0N997xui5+hvxcUhzXWTcjy7a8bXNICE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742841382; c=relaxed/simple;
	bh=ZOWLfl7LRUSe/2ZMujR1d7bxu0RxzXf5mmn9Rc/VfoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R89rXD1dpEW/BKqi1rFlpmn3L10KSvvIHxQctJ83c8pGAQ8o9FB3YotDXdkdqJsGntMMHYZ85fS0tXrqS8/JOBUmvoKEul0A32TyiEy2MBvNWoD10Qgm4QKAlSWAvoe9tsxPQqtrZP6d0+QDiLMzTIcd2mlO0cStdC3KF2jLKQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ix0kqUe+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742841380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8R1fhpCFsssJ/t2dthzX4ainTU9Kl3aOGNFVRr+jFug=;
	b=Ix0kqUe+sCWht1+FUvtxDH+8rgWo0xMvVFgVgEQRctITfY4tQRCWnRIsJwgRFZZZFIM56M
	GPqAr9Yx365q4C81cg91zfozkd7xpJfxtps5zcc0MWxn9w4OJDnbmQSgRGujRD+R/PFhr6
	j+8ETxIqcoKt+v+iQjYEA3AeUZUu8s0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303-lOe9r2n1OWa8sAE0mD5GXA-1; Mon,
 24 Mar 2025 14:36:16 -0400
X-MC-Unique: lOe9r2n1OWa8sAE0mD5GXA-1
X-Mimecast-MFC-AGG-ID: lOe9r2n1OWa8sAE0mD5GXA_1742841374
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7084196D2CC;
	Mon, 24 Mar 2025 18:36:14 +0000 (UTC)
Received: from redhat.com (unknown [10.22.81.75])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59476180A802;
	Mon, 24 Mar 2025 18:36:12 +0000 (UTC)
Date: Mon, 24 Mar 2025 14:36:09 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Filipe Xavier <felipeaggger@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, felipe_life@live.com
Subject: Re: [PATCH v2 1/2] selftests: livepatch: add new ftrace helpers
 functions
Message-ID: <Z+GmGfcdEceUzTQc@redhat.com>
References: <20250318-ftrace-sftest-livepatch-v2-0-60cb0aa95cca@gmail.com>
 <20250318-ftrace-sftest-livepatch-v2-1-60cb0aa95cca@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318-ftrace-sftest-livepatch-v2-1-60cb0aa95cca@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Mar 18, 2025 at 06:20:35PM -0300, Filipe Xavier wrote:
> [ ... snip ... ]
> 
> +	if [[ -n "$FTRACE_FILTER" ]]; then
> +		echo "$FTRACE_FILTER" \
> +			| sed -e "/#### all functions enabled ####/d"
> +			> "$SYSFS_TRACING_DIR/set_ftrace_filter"
> +	fi
  
Also, this may be more stylistic than a functional nit (I don't know for
sure), but shellcheck [1] seemed confused about these lines:

   In tools/testing/selftests/livepatch/functions.sh line 90:
                          > "$SYSFS_TRACING_DIR/set_ftrace_filter"
                          ^-- SC2188 (warning): This redirection doesn't have a command. Move to its command (or use 'true' as no-op).

I wasn't going to comment on these until I saw shellcheck note them, but
I thought shell script convention was typically to end the line with the
redirection/pipe then escape the end of line like:

  commands | commands > \
      tee output.txt

There are a few existing examples of this pattern if you grep the
functions.sh file for '\\$'.

That said, I'm far from certain whether which order is better than the
other.  The only reason for bringing it up is that shellcheck warns on
this patch's usage.

[1] https://www.shellcheck.net/

-- Joe


