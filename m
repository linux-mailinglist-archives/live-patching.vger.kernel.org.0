Return-Path: <live-patching+bounces-2066-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eG4pO5p1nGmwHwQAu9opvQ
	(envelope-from <live-patching+bounces-2066-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 16:43:22 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F1A178F05
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 16:43:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 91D9430314F4
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 15:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F0E2F5A12;
	Mon, 23 Feb 2026 15:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Up0jvo8n"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9432F363F
	for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 15:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771861347; cv=none; b=dq22g2ixoi9xFQ8KFcHHXEfrVV9w7WKhBMF/fUr/01D7xZ/EnopBGWmZ4R/PDsFPuQ59ptgwAXWse1TQbqzmmCR6efDUdYi174ohbeWgF9h8SMHlfIaoTuXSf3cyVKry9fP393TkdigHuo5XI/Bd8cNVjyjoqjXys0qhPMNos2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771861347; c=relaxed/simple;
	bh=LSiNPNXzwLpKVChiksX2grMZtsK+JQp+/bIkEQB55zY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SBz6gii0G875cqLTuDyjLkoVYxocZSnnYrtqobG3QD5lavi4/xOlzl9274779SOLZfvGbubHJ2RiC1pzee1Knz+7BYVRLQ7QK56L5ubpWctzbjwnqpLy8wu3np6YHOc7dXdRezHM4o1dU6gdxfSho77UmjkEA6iTJnw8wy+15vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Up0jvo8n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771861345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RqTYJnHoyg+L5RYQf85B8+7ExBu3bBAqANmRbn/MAEY=;
	b=Up0jvo8nqz2+ly0koSXnCjpvMkWAJ5KSy2Q3QHRwHzf+vMvr+Ga71ecDrNmgaTyKTPZoaQ
	E32d1/2lDdhOT4GP831IdcSPMkhz1xNkVfVH/3MNkiHTGmivjUIbFwVd8Q8W1iy6Ylnxjf
	M7UAaOwcXrqx7g1AZQaPiF7Uomnp27Y=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-eBENWJGnPNKyrM5tdU6kgQ-1; Mon,
 23 Feb 2026 10:42:21 -0500
X-MC-Unique: eBENWJGnPNKyrM5tdU6kgQ-1
X-Mimecast-MFC-AGG-ID: eBENWJGnPNKyrM5tdU6kgQ_1771861340
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D292F1956094;
	Mon, 23 Feb 2026 15:42:19 +0000 (UTC)
Received: from redhat.com (unknown [10.22.65.108])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B8C61800465;
	Mon, 23 Feb 2026 15:42:17 +0000 (UTC)
Date: Mon, 23 Feb 2026 10:42:14 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests: livepatch: functions.sh: Workaround
 heredoc on older bash
Message-ID: <aZx1ViTc7NJws-rf@redhat.com>
References: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
 <20260220-lp-test-trace-v1-2-4b6703cd01a6@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220-lp-test-trace-v1-2-4b6703cd01a6@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-2066-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 30F1A178F05
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 11:12:34AM -0300, Marcos Paulo de Souza wrote:
> When running current selftests on older distributions like SLE12-SP5 that
> contains an older bash trips over heredoc. Convert it to plain echo
> calls, which ends up with the same result.
> 

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

Just curious, what's the bash/heredoc issue?  All I could find via
google search was perhaps something to do with the temporary file
implementation under the hood.

--
Joe

> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>  tools/testing/selftests/livepatch/functions.sh | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
> index 8ec0cb64ad94..45ed04c6296e 100644
> --- a/tools/testing/selftests/livepatch/functions.sh
> +++ b/tools/testing/selftests/livepatch/functions.sh
> @@ -96,10 +96,8 @@ function pop_config() {
>  }
>  
>  function set_dynamic_debug() {
> -        cat <<-EOF > "$SYSFS_DEBUG_DIR/dynamic_debug/control"
> -		file kernel/livepatch/* +p
> -		func klp_try_switch_task -p
> -		EOF
> +	echo "file kernel/livepatch/* +p" > "$SYSFS_DEBUG_DIR/dynamic_debug/control"
> +	echo "func klp_try_switch_task -p" > "$SYSFS_DEBUG_DIR/dynamic_debug/control"
>  }
>  
>  function set_ftrace_enabled() {
> 
> -- 
> 2.52.0
> 


