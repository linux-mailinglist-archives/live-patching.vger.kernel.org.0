Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039144EA56
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2019 16:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfFUOPM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 Jun 2019 10:15:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfFUOPM (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 Jun 2019 10:15:12 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A9BD30089B5;
        Fri, 21 Jun 2019 14:15:12 +0000 (UTC)
Received: from redhat.com (ovpn-121-168.rdu2.redhat.com [10.10.121.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 36F3060CA3;
        Fri, 21 Jun 2019 14:15:11 +0000 (UTC)
Date:   Fri, 21 Jun 2019 10:15:08 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/5] livepatch: Documentation of the new API for tracking
 system state changes
Message-ID: <20190621141508.GD20356@redhat.com>
References: <20190611135627.15556-1-pmladek@suse.com>
 <20190611135627.15556-5-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611135627.15556-5-pmladek@suse.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 21 Jun 2019 14:15:12 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 11, 2019 at 03:56:26PM +0200, Petr Mladek wrote:
> Documentation explaining the motivation, capabilities, and usage
> of the new API for tracking system state changes.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  Documentation/livepatch/index.rst        |  1 +
>  Documentation/livepatch/system-state.rst | 80 ++++++++++++++++++++++++++++++++
>  2 files changed, 81 insertions(+)
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
> diff --git a/Documentation/livepatch/system-state.rst b/Documentation/livepatch/system-state.rst
> new file mode 100644
> index 000000000000..3a35073a0b80
> --- /dev/null
> +++ b/Documentation/livepatch/system-state.rst
> @@ -0,0 +1,80 @@
> [ ... snip ... ]
> +1. Livepatch compatibility

nit: 2. Livepatch compatibility

-- Joe
