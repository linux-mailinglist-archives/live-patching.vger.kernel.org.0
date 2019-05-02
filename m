Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EB511844
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 13:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfEBLmW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 May 2019 07:42:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:49786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbfEBLmW (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 May 2019 07:42:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3B850AE92;
        Thu,  2 May 2019 11:42:21 +0000 (UTC)
Date:   Thu, 2 May 2019 13:42:20 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     "Tobin C. Harding" <tobin@kernel.org>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] kobject: Add and use init predicate
In-Reply-To: <20190502023142.20139-1-tobin@kernel.org>
Message-ID: <alpine.LSU.2.21.1905021341220.16827@pobox.suse.cz>
References: <20190502023142.20139-1-tobin@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> Testing
> -------
> 
> Kernel build configuration
> 
> 	$ egrep LIVEPATCH .config
> 	CONFIG_HAVE_LIVEPATCH=y
> 	CONFIG_LIVEPATCH=y
> 	CONFIG_TEST_LIVEPATCH=m
> 
> 	$ egrep FTRACE .config
> 	CONFIG_KPROBES_ON_FTRACE=y
> 	CONFIG_HAVE_KPROBES_ON_FTRACE=y
> 	CONFIG_HAVE_DYNAMIC_FTRACE=y
> 	CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> 	CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> 	CONFIG_FTRACE=y
> 	CONFIG_FTRACE_SYSCALLS=y
> 	CONFIG_DYNAMIC_FTRACE=y
> 	CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
> 	CONFIG_FTRACE_MCOUNT_RECORD=y
> 	# CONFIG_FTRACE_STARTUP_TEST is not set
> 
> Builds fine but doesn't boot in Qemu.  I've never run dynamic Ftrace, it
> appears to crash during this.  Was hoping to run the livepatch tests but
> not sure how to at this moment.  Is dynamic Ftrace and livepatch testing
> something that can even be done in a VM or do I need to do this or
> baremetal?

It definitely should work in VM/qemu. We use it like that all the time.

Miroslav
