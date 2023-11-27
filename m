Return-Path: <live-patching+bounces-45-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D5C87FAA84
	for <lists+live-patching@lfdr.de>; Mon, 27 Nov 2023 20:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB89FB20F35
	for <lists+live-patching@lfdr.de>; Mon, 27 Nov 2023 19:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 478713FB0F;
	Mon, 27 Nov 2023 19:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gmFwaDNn"
X-Original-To: live-patching@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EE285;
	Mon, 27 Nov 2023 11:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=OsdhkKJ5OBibEks8cALyIRkF9z2Sypb7e/dUXuahLro=; b=gmFwaDNnI3MpTvA3NLaNqMx6n2
	qOsXPFM40yQEZRD9AO4GKWLKA4BNpM6SVFRUKvduXXFptAPkgP2LVAmvi/DQCt2hVfI7MbAux7R9q
	qizF6/lDqadMjTBNTse9KqK0tlBXuwoSwl+UZ+h8vLihwv2bYokQZODkeNrfNyo2S3UGb+OkNtCwg
	3hBVpJZrdpMhWofoZSmXloSecC+MiY9bWFajhAz7YakMGYR9ZMM6AMd3QZGwqunq4EBvMPH3BKOko
	dsXswAgGMge/iiBtnZ12fiTWlKzjZNjRVb7ecvBA7jNi0CF78o4gR8yIW5v4MB7QN1C+rOzSp8iAS
	Q29QGwZw==;
Received: from [50.53.46.231] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r7hU5-003NeL-38;
	Mon, 27 Nov 2023 19:41:34 +0000
Message-ID: <202dbdf5-1adf-4ffa-a50d-0424967286ba@infradead.org>
Date: Mon, 27 Nov 2023 11:41:31 -0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Took care of some grammatical mistakes
Content-Language: en-US
To: attreyee-muk <tintinm2017@gmail.com>, jpoimboe@kernel.org,
 jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com,
 corbet@lwn.net
Cc: live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231127155758.33070-1-tintinm2017@gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20231127155758.33070-1-tintinm2017@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 11/27/23 07:57, attreyee-muk wrote:
> Respected Maintainers, 
> 
> I have made some grammatical changes in the livepatch.rst file where I
> felt that the sentence would have sounded more correct and would have become easy for
> beginners to understand by reading. 
> Requesting review of my proposed changes from the mainatiners. 
> 
> Thank You
> Attreyee Mukherjee
> 
> Signed-off-by: attreyee-muk <tintinm2017@gmail.com>
> ---
>  Documentation/livepatch/livepatch.rst | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
> index 68e3651e8af9..a2d2317b7d6b 100644
> --- a/Documentation/livepatch/livepatch.rst
> +++ b/Documentation/livepatch/livepatch.rst
> @@ -35,11 +35,11 @@ and livepatching:
>  
>  All three approaches need to modify the existing code at runtime. Therefore
> -they need to be aware of each other and not step over each other's toes.
> +they need to be aware of each other and not step over each others' toes.

I've never seen that written like that, so I disagree here. FWIW.

>  Most of these problems are solved by using the dynamic ftrace framework as
>  a base. A Kprobe is registered as a ftrace handler when the function entry
>  is probed, see CONFIG_KPROBES_ON_FTRACE. Also an alternative function from

thanks.
-- 
~Randy

