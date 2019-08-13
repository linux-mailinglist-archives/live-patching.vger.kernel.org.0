Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6707F8BAA0
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2019 15:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbfHMNnS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 13 Aug 2019 09:43:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:58534 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728338AbfHMNnR (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 13 Aug 2019 09:43:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6AF5EAD05;
        Tue, 13 Aug 2019 13:43:16 +0000 (UTC)
Date:   Tue, 13 Aug 2019 15:43:11 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] livepatch: Documentation of the new API for
 tracking system state changes
In-Reply-To: <20190719074034.29761-5-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.1908131538010.10477@pobox.suse.cz>
References: <20190719074034.29761-1-pmladek@suse.com> <20190719074034.29761-5-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 19 Jul 2019, Petr Mladek wrote:

> Documentation explaining the motivation, capabilities, and usage
> of the new API for tracking system state changes.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  Documentation/livepatch/index.rst        |   1 +
>  Documentation/livepatch/system-state.rst | 167 +++++++++++++++++++++++++++++++
>  2 files changed, 168 insertions(+)
>  create mode 100644 Documentation/livepatch/system-state.rst
> 
> diff --git a/Documentation/livepatch/index.rst b/Documentation/livepatch/index.rst
> index edd291d51847..94bbbc2c8993 100644
> --- a/Documentation/livepatch/index.rst
> +++ b/Documentation/livepatch/index.rst
> @@ -9,6 +9,7 @@ Kernel Livepatching
>  
>      livepatch
>      callbacks
> +    system-state
>      cumulative-patches
>      module-elf-format
>      shadow-vars

This is really a nitpick, but wouldn't it be better to move system-state 
to the end of the list, because it relies on the information from the 
other parts?

> diff --git a/Documentation/livepatch/system-state.rst b/Documentation/livepatch/system-state.rst
> new file mode 100644
> index 000000000000..f04ef2b9089a
> --- /dev/null
> +++ b/Documentation/livepatch/system-state.rst
> @@ -0,0 +1,167 @@
> +====================
> +System State Changes
> +====================
> +
> +Some users are really reluctant to reboot a system. This brings the need
> +to provide more livepatches and maintain some compatibility between them.
> +
> +Maintaining more livepatches is much easier with cumulative livepatches.
> +Each new livepatch completely replaces any older one. It can keep,
> +add, and even remove fixes. And it is typically safe to replace any version
> +of the livepatch with any other one thanks to the atomic replace feature.
> +
> +The problems might come with shadow variables and callbacks. They might
> +change the system behavior or state so that it is not longer safe to

s/not longer/no longer/ (there are more instances of this in the patch).

Miroslav
