Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DFA16C070
	for <lists+live-patching@lfdr.de>; Tue, 25 Feb 2020 13:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgBYMLa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Feb 2020 07:11:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:44374 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729033AbgBYMLa (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Feb 2020 07:11:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A48AFAC66;
        Tue, 25 Feb 2020 12:11:27 +0000 (UTC)
Date:   Tue, 25 Feb 2020 13:11:25 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-team@android.com, akpm@linux-foundation.org,
        "K . Prasad" <prasad@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Quentin Perret <qperret@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 0/3] Unexport kallsyms_lookup_name() and
 kallsyms_on_each_symbol()
Message-ID: <20200225121125.psvuz6e7coa77vxe@pathway.suse.cz>
References: <20200221114404.14641-1-will@kernel.org>
 <alpine.LSU.2.21.2002251104130.11531@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2002251104130.11531@pobox.suse.cz>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2020-02-25 11:05:39, Miroslav Benes wrote:
> CC live-patching ML, because this could affect many of its users...
> 
> On Fri, 21 Feb 2020, Will Deacon wrote:
> 
> > Hi folks,
> > 
> > Despite having just a single modular in-tree user that I could spot,
> > kallsyms_lookup_name() is exported to modules and provides a mechanism
> > for out-of-tree modules to access and invoke arbitrary, non-exported
> > kernel symbols when kallsyms is enabled.

Just to explain how this affects livepatching users.

Livepatch is a module that inludes fixed copies of functions that
are buggy in the running kernel. These functions often
call functions or access variables that were defined static in
the original source code. There are two ways how this is currently
solved.

Some livepatch authors use kallsyms_lookup_name() to locate the
non-exported symbols in the running kernel and then use these
address in the fixed code.

Another possibility is to used special relocation sections,
see Documentation/livepatch/module-elf-format.rst

The problem with the special relocations sections is that the support
to generate them is not ready yet. The main piece would klp-convert
tool. Its development is pretty slow. The last version can be
found at
https://lkml.kernel.org/r/20190509143859.9050-1-joe.lawrence@redhat.com

I am not sure if this use case is enough to keep the symbols exported.
Anyway, there are currently some out-of-tree users.

Best Regards,
Petr
