Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547CE1CDB04
	for <lists+live-patching@lfdr.de>; Mon, 11 May 2020 15:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgEKNQE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 11 May 2020 09:16:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:51376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgEKNQE (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 11 May 2020 09:16:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F2E04AC22;
        Mon, 11 May 2020 13:16:05 +0000 (UTC)
Date:   Mon, 11 May 2020 15:16:02 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Update LIVE PATCHING file list
In-Reply-To: <20200511061014.308675-1-kamalesh@linux.vnet.ibm.com>
Message-ID: <alpine.LSU.2.21.2005111515460.7586@pobox.suse.cz>
References: <20200511061014.308675-1-kamalesh@linux.vnet.ibm.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 11 May 2020, Kamalesh Babulal wrote:

> The current list of livepatching files is incomplete, update the list
> with the missing files. Included files are ordered by the command:
> 
> ./scripts/parse-maintainers.pl --input=MAINTAINERS --output=MAINTAINERS --order
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Acked-by: Miroslav Benes <mbenes@suse.cz>

M
