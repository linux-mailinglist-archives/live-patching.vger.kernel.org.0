Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DC51C8648
	for <lists+live-patching@lfdr.de>; Thu,  7 May 2020 12:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgEGKAk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 May 2020 06:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgEGKAS (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 May 2020 06:00:18 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A814C21473;
        Thu,  7 May 2020 10:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588845617;
        bh=bcDuPlK5Eisv/i5AZHvazLLY9XdRx5lz+/uXpfp9JV0=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=JjsIhurgsHOjFr9qWqQvkxxcy4ipTQLatYA569lhQObBh7lN947EJYsDjpAkEAPIa
         DEd0T3Jgb+mzWPee30GaH8plLJnVLwybi9eLGgyaqYjQlqzle0e8UabNznG975H/3X
         3xHy2ae0ORM+laxQcVbParXO5zgCRycV6E8D8dpM=
Date:   Thu, 7 May 2020 12:00:13 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-s390@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v4 06/11] s390/module: Use s390_kernel_write() for late
 relocations
In-Reply-To: <4710f82c960ff5f8b0dd7dba6aafde5bea275cfa.1588173720.git.jpoimboe@redhat.com>
Message-ID: <nycvar.YFH.7.76.2005071159490.25812@cbobk.fhfr.pm>
References: <cover.1588173720.git.jpoimboe@redhat.com> <4710f82c960ff5f8b0dd7dba6aafde5bea275cfa.1588173720.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 29 Apr 2020, Josh Poimboeuf wrote:

> From: Peter Zijlstra <peterz@infradead.org>
> 
> Because of late module patching, a livepatch module needs to be able to
> apply some of its relocations well after it has been loaded.  Instead of
> playing games with module_{dis,en}able_ro(), use existing text poking
> mechanisms to apply relocations after module loading.
> 
> So far only x86, s390 and Power have HAVE_LIVEPATCH but only the first
> two also have STRICT_MODULE_RWX.
> 
> This will allow removal of the last module_disable_ro() usage in
> livepatch.  The ultimate goal is to completely disallow making
> executable mappings writable.
> 
> [ jpoimboe: Split up patches.  Use mod state to determine whether
> 	    memcpy() can be used.  Test and add fixes. ]
> 
> Cc: linux-s390@vger.kernel.org
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
> Acked-by: Miroslav Benes <mbenes@suse.cz>

Could we please get an Ack / Reviewed-by: for this patch from s390 folks?

Thanks,

-- 
Jiri Kosina
SUSE Labs

