Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCCC32EBBD
	for <lists+live-patching@lfdr.de>; Fri,  5 Mar 2021 13:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhCEM6R (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 5 Mar 2021 07:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCEM56 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 5 Mar 2021 07:57:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E7CC061574;
        Fri,  5 Mar 2021 04:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=E4zAsZ5KfOS58Mub4kjBw1ywIIeg5uqeQFS+lr39D5E=; b=soVnXOPKQw3ABgITyPB/1EM6LF
        wrRSs2Bpc6ozm7brGih5qYthbwAyJNtTzkv7tKLKQ2nZnofMmpQ3DKDdITixqN6iblMqs0CCzpRto
        giPrOLi4rqW1R/Qym+tict0Q43oQuEkmEa87pcQ4xL+L3VmLmrPKC1KS/N672EMLF2TytHshIAcaI
        SmXAhGa4orUCcf+KX8VfF9spfrw8kapHrQDj13rpRJCz/3tT8W2KCJ9ZyVC9e0lG06sGDBX07Yfmi
        Wg6ih/YnqsCk/bQu/58p0MuR4s4x2/j7tAd+kxgP7h89guhaHzyNmQSv7Aw6f6ijeV4UdAmZ5QoEC
        Ta/3psmg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lI9zs-00BiMe-PX; Fri, 05 Mar 2021 12:56:12 +0000
Date:   Fri, 5 Mar 2021 12:56:00 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com, corbet@lwn.net,
        live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH V2] docs: livepatch: Fix a typo and remove the
 unnecessary gaps in a sentence
Message-ID: <20210305125600.GM2723601@casper.infradead.org>
References: <20210305100923.3731-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305100923.3731-1-unixbhaskar@gmail.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Mar 05, 2021 at 03:39:23PM +0530, Bhaskar Chowdhury wrote:
> s/varibles/variables/
> 
> ...and remove leading spaces from a sentence.

What do you mean 'leading spaces'?  Separating two sentences with
one space or two is a matter of personal style, and we do not attempt
to enforce a particular style in the kernel.

>  Sometimes it may not be convenient or possible to allocate shadow
>  variables alongside their parent objects.  Or a livepatch fix may
> -require shadow varibles to only a subset of parent object instances.  In
> +require shadow variables to only a subset of parent object instances.

wrong preposition, s/to/for/
