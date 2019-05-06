Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A584E14E69
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2019 17:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfEFPAB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 May 2019 11:00:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:48462 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726739AbfEFPAB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 May 2019 11:00:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0824ADF2;
        Mon,  6 May 2019 14:59:59 +0000 (UTC)
Date:   Mon, 6 May 2019 16:59:55 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, live-patching@vger.kernel.org
Subject: Re: [PATCH 0/2] livepatch/docs: Convert livepatch documentation to
 the ReST format
In-Reply-To: <20190503143024.28358-1-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.1905061658500.19850@pobox.suse.cz>
References: <20190503143024.28358-1-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 3 May 2019, Petr Mladek wrote:

> This is the original Mauro's patch and my extra fixup as a clean
> patchset.
> 
> I want to be sure that other livepatching maintainers are fine
> with the changes ;-)
> 
> 
> Mauro Carvalho Chehab (1):
>   docs: livepatch: convert docs to ReST and rename to *.rst
> 
> Petr Mladek (1):
>   docs/livepatch: Unify style of livepatch documentation in the ReST
>     format
> 
>  Documentation/ABI/testing/sysfs-kernel-livepatch   |   2 +-
>  .../livepatch/{callbacks.txt => callbacks.rst}     |  45 +--
>  ...mulative-patches.txt => cumulative-patches.rst} |  14 +-
>  Documentation/livepatch/index.rst                  |  21 ++
>  .../livepatch/{livepatch.txt => livepatch.rst}     |  62 ++--
>  ...module-elf-format.txt => module-elf-format.rst} | 353 +++++++++++----------
>  .../livepatch/{shadow-vars.txt => shadow-vars.rst} |  65 ++--
>  tools/objtool/Documentation/stack-validation.txt   |   2 +-
>  8 files changed, 307 insertions(+), 257 deletions(-)
>  rename Documentation/livepatch/{callbacks.txt => callbacks.rst} (87%)
>  rename Documentation/livepatch/{cumulative-patches.txt => cumulative-patches.rst} (89%)
>  create mode 100644 Documentation/livepatch/index.rst
>  rename Documentation/livepatch/{livepatch.txt => livepatch.rst} (93%)
>  rename Documentation/livepatch/{module-elf-format.txt => module-elf-format.rst} (55%)
>  rename Documentation/livepatch/{shadow-vars.txt => shadow-vars.rst} (87%)

Acked-by: Miroslav Benes <mbenes@suse.cz>

Miroslav
